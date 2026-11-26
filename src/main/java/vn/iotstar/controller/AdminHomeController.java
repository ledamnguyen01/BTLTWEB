package vn.iotstar.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import vn.iotstar.service.CategoryService;
import vn.iotstar.service.UserService;

@Controller
@RequestMapping("/admin")
public class AdminHomeController {

    private final CategoryService categoryService;
    private final UserService userService;

    public AdminHomeController(CategoryService categoryService, UserService userService) {
        this.categoryService = categoryService;
        this.userService = userService;
    }

    @GetMapping({ "", "/", "/home" })
    public String dashboard(Model model) {
        model.addAttribute("totalCategories", categoryService.count());
        model.addAttribute("totalUsers", userService.count());
        return "admin/home";
    }
}
