package com.one.touring;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class HomeController {
   @GetMapping("/")
   public String home() {
      return "home";
   }
   @GetMapping("/inquiry")
   public String inquiry() {
      return "/include/inquiry";
   }
   @GetMapping("/chart")
   public String chart() {
      return "/include/chart";
   }
}