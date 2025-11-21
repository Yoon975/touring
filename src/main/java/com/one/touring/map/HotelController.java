package com.one.touring.map;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import java.util.Map;

@RestController
public class HotelController {

    private final String kakaoApiKey = "0f3ca47f756485555f44f6bbcdcc7a5d"; // REST API Å°
    private final RestTemplate restTemplate = new RestTemplate();

    @GetMapping("/hotel/nearby")
    public Map getHotels(@RequestParam String lat, @RequestParam String lng) {
        try {
            String url = "https://dapi.kakao.com/v2/local/search/keyword.json?y=" + lat + "&x=" + lng + "&radius=2000&query=È£ÅÚ";
            HttpHeaders headers = new HttpHeaders();
            headers.set("Authorization", "KakaoAK " + kakaoApiKey);
            HttpEntity<String> entity = new HttpEntity<>(headers);
            ResponseEntity<Map> response = restTemplate.exchange(url, HttpMethod.GET, entity, Map.class);
            return response.getBody();
        } catch (Exception e) {
            e.printStackTrace();
            return Map.of("error", e.getMessage());
        }
    }
}
