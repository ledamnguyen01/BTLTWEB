package vn.iotstar.config;

import org.sitemesh.builder.SiteMeshFilterBuilder;
import org.sitemesh.config.ConfigurableSiteMeshFilter;

public class CustomSiteMeshFilter extends ConfigurableSiteMeshFilter {

    @Override
    protected void applyCustomConfiguration(SiteMeshFilterBuilder builder) {
        // spring-boot-starter-sitemesh mặc định prefix /WEB-INF/decorators/
        builder.addDecoratorPath("/*", "web.jsp")
               .addDecoratorPath("/admin/*", "admin.jsp")
               // Loại trừ trang auth standalone, tài nguyên tĩnh, ảnh upload và API
               .addExcludedPath("/login*")
               .addExcludedPath("/login/*")
               .addExcludedPath("/alogin*")
               .addExcludedPath("/alogin/*")
               .addExcludedPath("/register*")
               .addExcludedPath("/register/*")
               .addExcludedPath("/static/*")
               .addExcludedPath("/uploads/*")
               .addExcludedPath("/api/*")
               .addExcludedPath("/api/**");
    }
}
