package vn.iotstar.controller;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import vn.iotstar.service.CategoryService;
import vn.iotstar.service.UserService;

@Controller
public class HomeController {

    private final CategoryService categoryService;
    private final UserService userService;

    public HomeController(CategoryService categoryService, UserService userService) {
        this.categoryService = categoryService;
        this.userService = userService;
    }

    @GetMapping({ "/", "/home" })
    public String home(Model model, @RequestParam(name = "error", required = false) String error) {
        if ("forbidden".equals(error)) {
            model.addAttribute("alert", "Bạn không có quyền truy cập khu vực Quản trị (Admin)!");
        }
        model.addAttribute("categories", categoryService.findAll(PageRequest.of(0, 8, Sort.by("id").ascending())).getContent());
        model.addAttribute("totalCategories", categoryService.count());
        model.addAttribute("totalUsers", userService.count());
        return "web/home";
    }
}
