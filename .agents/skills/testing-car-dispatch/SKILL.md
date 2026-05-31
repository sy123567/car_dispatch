---
name: testing-car-dispatch
description: End-to-end test the car_dispatch fleet management system (员工用车申请, 司机维修事务, 管理员车辆管理, 仪表盘真实数据). Use when verifying UI/servlet changes in this repo.
---

# Testing car_dispatch (公司用车管理系统)

Java Servlet + JSP + MySQL fleet management app. Roles: 管理员(admin) / 员工(employee) / 司机(driver) / 审批人(approver).

## Build & Deploy
- Source root: `dzuoye/car/` (Maven). Build: `mvn clean package -DskipTests` → `target/car.war`.
- Deploy to Tomcat 10.1, app context `/car` → `http://localhost:8080/car`.
- After a VM restart Tomcat process is killed (code persists) — restart Tomcat and re-confirm deployment before testing.
- Remote MySQL DB `big_homework_car_system` (connection config in the app's DB util / `db.properties`). The app reads/writes live data; tests should verify rows actually land in the DB.

## Test Accounts
- 管理员(admin): `123456 / 123456`
- 员工(employee): `000000 / 123456`
- 司机(driver): `666666 / 123456`

## Core flows to verify
1. **员工提交/取消用车申请**: 用车申请 form → 提交申请 → should redirect to 我的申请 (`/carApply?action=myList`) with green success banner and the new 待审批 application visible; 取消 also returns to myList. Pagination should show a numeric count (not `null`).
2. **仪表盘真实数据 (adversarial)**: admin → 仪表盘 (`/index`). Stats (申请总数 / 已审批 / 可用车辆 / 在岗司机) and the 待审批申请 + 最近派车 tables must reflect live DB values, NOT hardcoded placeholders (128/96/24/18, 张三/李四, 京A-12345). Submitting an employee application first, then checking the dashboard count increments, proves data is DB-driven.
3. **司机维修事务**: driver → 维修事务 (`/repair`) → 新增报修 (modal `openRepairModal()`, fields carId/faultDesc/repairUnitName/totalCost) → 提交报修 → 工单 `WX...` 待审批 入列. 取消 form posts `action=cancel&workOrderNo=...` with a `confirm()` guard → 报修已取消, row removed.
4. **管理员添加车辆**: admin → 车辆管理 (`/car`) → 新增车辆 (modal `openAddCar()`, id `carModal`, fields licensePlate/brand/model/displacement/drivingLicenseNo/carStatusId) → 保存 → 添加成功 + new row.

Recommended order: 1 → 2 → 3 → 4, so the dashboard in step 2 reflects step 1's submission.

## Custom-cursor overlay click workaround
This app renders a custom cursor overlay (cursor-dot/cursor-ring, z-index 100000) that intercepts native mouse clicks on buttons inside modals/forms. If a native click does nothing:
- Open modals via their JS opener: `openRepairModal()`, `openAddCar()`.
- Fill Chinese fields and submit via `browser_console`: set input `.value` + dispatch `input`/`change` events, then call the submit button's `.click()` or `form.submit()`.
- This follows the exact same server code path; only the UI gesture is bypassed. Note this in the report.
- For `datetime-local` inputs, set `.value = 'YYYY-MM-DDTHH:mm'` via console (keystroke entry is unreliable).

## DB verification (read-only)
Verify persistence with a small JDBC program (mysql-connector jar is under `dzuoye/car/target/car/WEB-INF/lib/`). Key tables/columns (note Chinese column names):
- `车辆`: `ID, 车牌号, 品牌, 车型, 排量, 行驶证号, 车辆状态(1=空闲), 年检到期日 ...`
- `用车申请`: `申请ID, 员工ID, 用车日期, 目的地, 申请状态, ...`
- `维修申请`: `工单号, 申请人ID, 车ID, 故障描述, 维修单位名, 维修总费用, 审批状态(待审批), ...`
Use `information_schema.columns` to confirm exact column names if a query errors (PK is `ID` for 车辆, not `车辆ID`).

## Notes
- No CI in this repo; the running app + DB is the test target.
- `car_apply_dispatch.jsp` is a dead static mockup page (not routed) — historically the source of the "submit button does nothing" symptom (employee was redirected there). Don't confuse it with the real myList page.

## Devin Secrets Needed
- None required for testing — DB credentials are baked into the app config and test accounts are listed above. (If the remote DB ever requires externalized credentials, request them as a session secret rather than hardcoding.)
