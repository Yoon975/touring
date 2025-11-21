package com.one.touring.map;

import java.util.List;
import java.util.Map;

import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

@RestController
@RequestMapping("/map/duration")
public class NaviController {

    private final String kakaoRestApiKey = "0f3ca47f756485555f44f6bbcdcc7a5d";
    private final RestTemplate restTemplate = new RestTemplate();

    @GetMapping("/navi/time")
    public Map<String, Object> getDuration(@RequestParam String origin, @RequestParam String destination) {
        String url = "https://apis-navi.kakaomobility.com/v1/directions?origin=" + origin + "&destination=" + destination;
        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "KakaoAK " + kakaoRestApiKey);

        ResponseEntity<Map> response = restTemplate.exchange(url, HttpMethod.GET, new HttpEntity<>(headers), Map.class);

        List<Map<String,Object>> routes = (List<Map<String,Object>>) response.getBody().get("routes");
        if(routes != null && !routes.isEmpty()) {
            Map<String,Object> summary = (Map<String,Object>) routes.get(0).get("summary");
            return Map.of("duration", summary.get("duration"));
        }
        return Map.of("duration", null);
    }
}
