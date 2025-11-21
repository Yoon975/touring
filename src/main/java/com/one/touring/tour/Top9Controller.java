package com.one.touring.tour;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.xml.parsers.SAXParserFactory;
import javax.xml.stream.*;
import javax.xml.stream.events.XMLEvent;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.*;

@Controller
public class Top9Controller {

    private static final String SERVICE_KEY = "66261357-688d-495b-98b5-b92a031ca7f8";
    private static final String API_URL = "https://api.kcisa.kr/openapi/service/rest/convergence2018/conver8";

    @GetMapping("/top9api")
    @ResponseBody
    public List<Map<String, Object>> getTop9() throws Exception {

        // ✅ 1. URL 구성
        StringBuilder urlBuilder = new StringBuilder(API_URL);
        urlBuilder.append("?serviceKey=").append(URLEncoder.encode(SERVICE_KEY, "UTF-8"));
        urlBuilder.append("&numOfRows=").append(URLEncoder.encode("500", "UTF-8")); // 많이 가져오기
        urlBuilder.append("&pageNo=").append(URLEncoder.encode("1", "UTF-8"));

        // ✅ 2. 연결 및 XML 응답 받기
        URL url = new URL(urlBuilder.toString());
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");

        BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = rd.readLine()) != null) sb.append(line);
        rd.close();
        conn.disconnect();

        // ✅ 3. XML 파싱 (StAX 사용)
        XMLInputFactory factory = XMLInputFactory.newInstance();
        XMLEventReader reader = factory.createXMLEventReader(new java.io.StringReader(sb.toString()));

        Map<String, Integer> visitorMap = new HashMap<>();
        String currentTag = "";
        String sido = "";
        int visitor = 0;

        while (reader.hasNext()) {
            XMLEvent event = reader.nextEvent();

            if (event.isStartElement()) {
                currentTag = event.asStartElement().getName().getLocalPart();
            } else if (event.isCharacters()) {
                String data = event.asCharacters().getData().trim();
                if (!data.isEmpty()) {
                    switch (currentTag) {
                        case "sido":
                            sido = data;
                            break;
                        case "visitor":
                            try {
                                visitor = Integer.parseInt(data);
                            } catch (NumberFormatException e) {
                                visitor = 0;
                            }
                            break;
                    }
                }
            } else if (event.isEndElement()) {
                String endTag = event.asEndElement().getName().getLocalPart();
                if (endTag.equals("item")) {
                    // 시도별 합산
                    if (!sido.isEmpty()) {
                        visitorMap.put(sido, visitorMap.getOrDefault(sido, 0) + visitor);
                    }
                    sido = "";
                    visitor = 0;
                }
            }
        }

        // ✅ 4. 결과 정렬 (방문객수 기준 내림차순)
        List<Map<String, Object>> topList = new ArrayList<>();
        visitorMap.entrySet().stream()
                .sorted((a, b) -> b.getValue().compareTo(a.getValue()))
                .limit(9)
                .forEach(entry -> {
                    Map<String, Object> map = new LinkedHashMap<>();
                    map.put("시도명", entry.getKey());
                    map.put("방문객수", entry.getValue());
                    topList.add(map);
                });

        return topList;
    }
}
