package com.haivn.authenticate;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.Arrays;

@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity(prePostEnabled = true)
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Autowired
    private JwtRequestFilter jwtRequestFilter;

    @Override
    public void configure(WebSecurity web) {
        web.ignoring().antMatchers("/swagger-ui/**", "/v3/api-docs/**");
    }

    @Override
    public void configure(HttpSecurity http) throws Exception {
        http.cors().and().csrf().disable().authorizeRequests()
                .antMatchers(PUBLIC_LIST)
                .permitAll()
                .antMatchers(ADMIN_LIST_PRIVATE)
                .hasAnyRole("ADMIN")
                .anyRequest().authenticated()
                .and()
                .sessionManagement()
                .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                .and()
                .logout().clearAuthentication(true).invalidateHttpSession(true)
                .and()
                .addFilterBefore(jwtRequestFilter, UsernamePasswordAuthenticationFilter.class);
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        final CorsConfiguration configuration = new CorsConfiguration();
        configuration.setAllowedOrigins(Arrays.asList("*"));
        configuration.setAllowedMethods(Arrays.asList("POST", "GET", "PUT", "DELETE", "HEAD", "OPTIONS"));
        configuration.setAllowCredentials(false);
        configuration.setAllowedHeaders(Arrays.asList("Authorization","Cache-Control","Content-Type"));
        final UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }

    String[] PUBLIC_LIST = {
//            "/api/test/post","/api/test/get/*","/api/test/put/*","/api/test/del/*",
            "/api/upload","/api/files/*", "/api/sinh-vien-thuc-tap/up-file-danh-sach/*","/api/nguoi-dung/sendEmail",
            "/api/nguoi-dung/create","/api/nguoi-dung/login","/api/nguoi-dung/get/*","/api/nguoi-dung/put/*","/api/nguoi-dung/del/*","/api/nguoi-dung/change-pass/*",
            "/api/doanh-nghiep/post","/api/doanh-nghiep/get/*","/api/doanh-nghiep/put/*","/api/doanh-nghiep/del/*",
            "/api/ke-hoach-thuc-tap/post","/api/ke-hoach-thuc-tap/get/*","/api/ke-hoach-thuc-tap/put/*","/api/ke-hoach-thuc-tap/del/*",
            "/api/giao-vien/post","/api/giao-vien/get/*","/api/giao-vien/put/*","/api/giao-vien/del/*",
            "/api/sinh-vien-thuc-tap/post","/api/sinh-vien-thuc-tap/get/*","/api/sinh-vien-thuc-tap/put/*","/api/sinh-vien-thuc-tap/del/*",
            "/api/file-gvhd-gui-sv/post","/api/file-gvhd-gui-sv/get/*","/api/file-gvhd-gui-sv/put/*","/api/file-gvhd-gui-sv/del/*",
            "/api/thong-bao-thuc-tap/post","/api/thong-bao-thuc-tap/get/*","/api/thong-bao-thuc-tap/put/*","/api/thong-bao-thuc-tap/del/*",
            "/api/nhat-ky-thuc-tap/post","/api/nhat-ky-thuc-tap/get/*","/api/nhat-ky-thuc-tap/put/*","/api/nhat-ky-thuc-tap/del/*",
            "/api/danh-gia-ket-qua/post","/api/danh-gia-ket-qua/get/*","/api/danh-gia-ket-qua/del/*","/api/danh-gia-ket-qua/put/*",
            "/api/khao-sat/post","/api/khao-sat/get/*","/api/khao-sat/put/*","/api/khao-sat/del/*",
            "/api/sinh-vien-khao-sat/post","/api/sinh-vien-khao-sat/get/*","/api/sinh-vien-khao-sat/put/*","/api/sinh-vien-khao-sat/del/*",
    };

    String[] ADMIN_LIST_PRIVATE = {
    };

}
