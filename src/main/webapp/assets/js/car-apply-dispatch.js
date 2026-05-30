document.addEventListener('DOMContentLoaded', function () {
    var menuItems = document.querySelectorAll('.menu-item');

    menuItems.forEach(function (item) {
        item.addEventListener('click', function () {
            menuItems.forEach(function (menu) {
                menu.classList.remove('active');
            });
            item.classList.add('active');
        });
    });
});
