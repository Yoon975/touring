package com.one.touring.tour;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import javax.servlet.ServletContext;

import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
public class TourUploadFileService implements InitializingBean{
	@Autowired
	private ServletContext servletContext;

	 // 저장 위치
    private String fileDir;
    
    @Override
    public void afterPropertiesSet() {
        fileDir = servletContext.getRealPath("/resources/img/tour");
        File dir = new File(fileDir);
        if (!dir.exists()) {
            dir.mkdirs();
        }
        System.out.println("파일 저장 경로: " + fileDir);
    }

    // 여러 파일 업로드 (관광지 tno 기준)
    public List<TourFileVo> upload(List<MultipartFile> multiList, int tno) {
        List<TourFileVo> fileDataList = new ArrayList<>();	
        try {
            for (MultipartFile file : multiList) {
                String oriFileName = file.getOriginalFilename(); // 원본 파일명
                String ext = oriFileName.substring(oriFileName.lastIndexOf(".")); // 확장자
                UUID uuid = UUID.randomUUID();
                String uniqueName = uuid.toString().replace("-", "");
                File saveFile = new File(fileDir + "\\" + uniqueName + ext);
                file.transferTo(saveFile);

                TourFileVo fileData = new TourFileVo();
                fileData.setTno(tno);
                System.out.println("파일 tno: " + tno);// 관광지 번호
                fileData.setToriginal(oriFileName);   // 원본 파일명
                fileData.setTfilename(uniqueName + ext); // 저장 파일명
                fileData.setSize(saveFile.length());   // 파일 크기

                System.out.println(fileData + " 업로드 완료");
                fileDataList.add(fileData);
                System.out.println(fileData.getTno());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return fileDataList;
    }

    // 단일 파일 업로드
    public String upload(MultipartFile imgFile) {
        String oriFileName = imgFile.getOriginalFilename(); // 원본 파일명
        System.out.println("원본 파일명: " + oriFileName);
        String ext = oriFileName.substring(oriFileName.lastIndexOf(".")); // 확장자
        UUID uuid = UUID.randomUUID();
        String unique = uuid.toString().replaceAll("-", "");
        File saveFile = new File(fileDir + "\\" + unique + ext);
        try {
            imgFile.transferTo(saveFile);
        } catch (Exception e) {
            e.printStackTrace();
        }
        System.out.println("저장 파일명: " + unique + ext);
        return unique + ext;
    }

    // 파일 삭제
    public void delete(String filename) {
        if (filename == null) return;
        File oldFile = new File(fileDir + "\\" + filename);
        if (oldFile.exists()) {
            oldFile.delete();
            System.out.println(filename + " 삭제 완료");
        }
    }
}