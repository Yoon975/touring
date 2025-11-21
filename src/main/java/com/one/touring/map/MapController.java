package com.one.touring.map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MapController {
    @GetMapping("/map/duration")
    public String showDurationPage() {
        return "map/duration";
    }

    @GetMapping("/map/hotel")
    public String showHotelsPage() {
        return "map/hotel";
    }
}

