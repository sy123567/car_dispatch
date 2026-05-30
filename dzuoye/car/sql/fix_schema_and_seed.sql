-- ============================================================
-- car_dispatch 数据库修复与初始化脚本
-- 目标库: big_homework_car_system
-- 作用:
--   1) 将基础表 driver 重命名为 司机(与 DAO/触发器/视图引用保持一致)
--   2) 为 用车申请 表补充 往返类型 / 备注 两列
--   3) 初始化 车辆状态 / 司机状态 参照数据
--   4) 删除存在逻辑错误(自表更新 + 状态值不匹配)的自动派车触发器,
--      改由 Java 端实现自动派车
--   5) 写入演示数据(车辆 / 司机),便于联调与评测
-- 脚本可重复执行(幂等)。
-- ============================================================

-- 1. 重命名司机表(仅当 driver 存在且 司机 不存在时执行)
DROP PROCEDURE IF EXISTS _rename_driver;
DELIMITER $$
CREATE PROCEDURE _rename_driver()
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'driver' AND TABLE_TYPE = 'BASE TABLE')
       AND NOT EXISTS (SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = '司机' AND TABLE_TYPE = 'BASE TABLE') THEN
        RENAME TABLE `driver` TO `司机`;
    END IF;
END$$
DELIMITER ;
CALL _rename_driver();
DROP PROCEDURE IF EXISTS _rename_driver;

-- 2. 用车申请补列(列已存在则跳过)
DROP PROCEDURE IF EXISTS _add_apply_cols;
DELIMITER $$
CREATE PROCEDURE _add_apply_cols()
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = '用车申请' AND COLUMN_NAME = '往返类型') THEN
        ALTER TABLE `用车申请` ADD COLUMN `往返类型` varchar(20) NULL COMMENT '单程/往返';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = '用车申请' AND COLUMN_NAME = '备注') THEN
        ALTER TABLE `用车申请` ADD COLUMN `备注` varchar(500) NULL;
    END IF;
END$$
DELIMITER ;
CALL _add_apply_cols();
DROP PROCEDURE IF EXISTS _add_apply_cols;

-- 3. 初始化状态参照表(空表才写入,保证 空闲=ID1)
INSERT INTO `车辆状态` (`车辆状态`, `状态描述`)
SELECT * FROM (
    SELECT '空闲' AS a, '可用,等待派车' AS b
    UNION ALL SELECT '使用中', '已派车/出车中'
    UNION ALL SELECT '维修中', '在修,不可派车'
    UNION ALL SELECT '已预约', '已被预约'
) t
WHERE NOT EXISTS (SELECT 1 FROM `车辆状态`);

INSERT INTO `司机状态` (`司机状态`, `状态描述`)
SELECT * FROM (
    SELECT '在岗' AS a, '在岗可派车' AS b
    UNION ALL SELECT '出车', '执行派车任务中'
    UNION ALL SELECT '休息', '休息中'
    UNION ALL SELECT '请假', '请假,不可派车'
) t
WHERE NOT EXISTS (SELECT 1 FROM `司机状态`);

-- 4. 删除有 bug 的自动派车触发器(自表 UPDATE 非法 + 状态值不匹配),改由 Java 实现
DROP TRIGGER IF EXISTS `trg_after_approve_auto_dispatch`;

-- 5. 演示数据:车辆(空闲)
INSERT INTO `车辆` (`车牌号`,`品牌`,`车型`,`购置日期`,`排量`,`行驶证号`,`车辆状态`,`年检到期日`,`保险到期日`)
SELECT * FROM (
    SELECT '赣A·10001' a,'丰田' b,'凯美瑞' c,'2022-03-01' d,'2.0L' e,'XSZ10001' f,
           (SELECT `ID` FROM `车辆状态` WHERE `车辆状态`='空闲' LIMIT 1) g,'2026-03-01' h,'2026-03-01' i
    UNION ALL SELECT '赣A·10002','大众','帕萨特','2021-06-15','1.8T','XSZ10002',
           (SELECT `ID` FROM `车辆状态` WHERE `车辆状态`='空闲' LIMIT 1),'2026-06-15','2026-06-15'
    UNION ALL SELECT '赣A·10003','别克','GL8','2023-01-10','2.0T','XSZ10003',
           (SELECT `ID` FROM `车辆状态` WHERE `车辆状态`='空闲' LIMIT 1),'2027-01-10','2027-01-10'
) t
WHERE NOT EXISTS (SELECT 1 FROM `车辆`);

-- 6. 演示数据:司机(在岗),并关联已有司机用户(账号 666666, 角色4)
INSERT INTO `司机` (`用户ID`,`姓名`,`工号`,`联系方式`,`驾驶证号`,`驾驶证有效期`,`从业资格证号`,`资格证有效期`,`司机状态`)
SELECT * FROM (
    SELECT (SELECT `ID` FROM `用户` WHERE `账号`='666666' LIMIT 1) u,'driver1' n,'D001' eno,'13800000001' c,
           'JSZ001' dl,'2027-01-01' de,'ZGZ001' q,'2027-01-01' qe,
           (SELECT `ID` FROM `司机状态` WHERE `司机状态`='在岗' LIMIT 1) s
    UNION ALL SELECT NULL,'李师傅','D002','13800000002','JSZ002','2027-05-01','ZGZ002','2027-05-01',
           (SELECT `ID` FROM `司机状态` WHERE `司机状态`='在岗' LIMIT 1)
) t
WHERE NOT EXISTS (SELECT 1 FROM `司机`);

-- 7. 修复"用车记录"插入后释放司机状态的触发器
-- 原触发器查找司机状态='空闲'，但司机状态参照表无'空闲'(只有 在岗/出车/休息/请假)，
-- 导致任务完成后司机无法释放。改为释放回'在岗'(兼容'空闲')。
DROP TRIGGER IF EXISTS trg_after_record_update_driver_status;
DELIMITER //
CREATE TRIGGER trg_after_record_update_driver_status
AFTER INSERT ON `用车记录`
FOR EACH ROW
BEGIN
    DECLARE v_空闲状态ID INT;
    DECLARE v_派车单司机ID INT;
    SELECT `ID` INTO v_空闲状态ID FROM `司机状态` WHERE `司机状态` IN ('在岗','空闲') ORDER BY `ID` LIMIT 1;
    SELECT `司机ID` INTO v_派车单司机ID FROM `派车单` WHERE `ID` = NEW.`派车单ID`;
    IF v_空闲状态ID IS NOT NULL AND v_派车单司机ID IS NOT NULL THEN
        UPDATE `司机` SET `司机状态` = v_空闲状态ID WHERE `ID` = v_派车单司机ID;
    END IF;
END//
DELIMITER ;
