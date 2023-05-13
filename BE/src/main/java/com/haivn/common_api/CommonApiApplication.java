package com.haivn.common_api;

import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.servers.Server;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.boot.web.servlet.ServletComponentScan;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.scheduling.TaskScheduler;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.concurrent.ConcurrentTaskScheduler;
import org.springframework.web.client.RestTemplate;

@ServletComponentScan
@SpringBootApplication
@EnableScheduling
@EnableAsync
@EnableJpaAuditing
@ComponentScan({"com.haivn"})
@EntityScan(basePackages = {"com.haivn.common_api", "com.haivn.authenticate"})
@EnableJpaRepositories(basePackages = {"com.haivn.repository"})
@OpenAPIDefinition(servers = {@Server(url="http://localhost:8088/", description = "Localhost")})
public class CommonApiApplication {
    public static void main(String[] args) {
        SpringApplication.run(CommonApiApplication.class, args);
    }

    @Bean
    public RestTemplate getRestTemplate() {
        return new RestTemplate();
    }

    @Bean
    public TaskScheduler taskScheduler() {
        return new ConcurrentTaskScheduler(); //single threaded by default
    }

}
