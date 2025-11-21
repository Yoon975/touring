package com.one.touring.tour;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class TourService {
	@Autowired
	TourDao tourDao;

    @Autowired
    private TourUploadFileService uploadFileService;
    
    // 키워드 + 카테고리 복합 검색
    public List<TourVo> searchTour(Integer tcno, String tregion, String keyword) {
        return tourDao.searchTour(tcno, tregion, keyword);
    }
    
    // tour 삭제
    public void deleteTour(int tno) {
        List<TourFileVo> fileDataList=tourDao.getFileData(tno);
        if (fileDataList.size()>0) {
           for(TourFileVo fileData:fileDataList) {
              uploadFileService.delete(fileData.getTfilename());
           }
           tourDao.deleteFileData(tno);
        }
        tourDao.deleteTour(tno);
     }
    
    // tour 수정 + 파일 수정
    public void updateTour(TourVo tourVo, List<TourFileVo> fileDataList, boolean fileUp) {
        tourDao.updateTour(tourVo);
        if (fileUp && fileDataList != null && !fileDataList.isEmpty()) {
            for (TourFileVo file : fileDataList) {
                file.setTno(tourVo.getTno());
                tourDao.insertTourFile(file);
            }
        }
    }

    // tour 개별 파일 삭제
    public void fileRemove(int tfno) {
        TourFileVo fileData = tourDao.getFileDataByTfno(tfno);
        if (fileData != null) {
            uploadFileService.delete(fileData.getTfilename());
            tourDao.removeFileData(tfno);
        }
    }
    
    // tour 등록
    @Transactional
    public int insertTour(TourVo tourVo) {
        return tourDao.insertTour(tourVo);
    }

    // tour 파일 등록
    public void insertTourFiles(List<TourFileVo> fileList) {
        for (TourFileVo fileVo : fileList) {
            tourDao.insertTourFile(fileVo);
        }
    }
	
    // tour 파일 불러오기
	public List<TourFileVo> getFileData(int tno) {
		return tourDao.getFileData(tno);
	}
	
	// tour 디테일 + 조회수
	public TourVo detailTour(int tno, boolean updateTourHit) {
		if(updateTourHit) {	//조회수 증가
			tourDao.updateTourHit(tno);
		}	
		TourVo tourVo=tourDao.detailTour(tno);
		List<TourFileVo> fildDataList=tourDao.getFileData(tno);
		tourVo.setFileDataList(fildDataList);
		return tourVo;
	}
	
	// tour 리스트
	public List<TourVo> selectListTour(){
		return tourDao.selectListTour();
	}
}
