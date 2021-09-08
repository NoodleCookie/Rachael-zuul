package thoughtworks.rachael.zuul.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.cloud.context.config.annotation.RefreshScope;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RefreshScope
public class RachaelZuulController {

    @Value("${test.property}")
    private String test_property;

    @GetMapping("/")
    public String index() {
        return "welcome to Rachael Zuul mirco server";
    }

    @GetMapping("/test")
    public String test(){
        return test_property;
    }
}
