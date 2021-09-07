package thoughtworks.rachael.zuul.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class RachaelZuulController {

    @GetMapping("/")
    public String index() {
        return "welcome to Rachael Zuul mirco server";
    }
}
