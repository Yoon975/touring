package com.one.touring.listener;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.io.BufferedReader;
import java.io.InputStreamReader;

public class StartupListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("[StartupListener] 서버 시작됨 → 여행지 순위 크롤링 시작...");

        try {
            // ✅ 파이썬 실행 파일 경로
            String pythonExe = "C:/Users/OWNER/anaconda3/python.exe";

            // ✅ 파이썬 스크립트 경로
            String scriptPath = "C:/workSpace/plot/update_travel_rank.py";

            ProcessBuilder pb = new ProcessBuilder(pythonExe, scriptPath);
            pb.redirectErrorStream(true);

            Process process = pb.start();

            // ✅ 실행 로그 읽기
            try (BufferedReader reader = new BufferedReader(
                    new InputStreamReader(process.getInputStream(), "UTF-8"))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    System.out.println("[Python] " + line);
                }
            }

            int exitCode = process.waitFor();
            System.out.println(" 파이썬 스크립트 실행 완료 (exit code: " + exitCode + ")");
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("파이썬 실행 중 오류 발생!");
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("서버 종료됨");
    }
}
