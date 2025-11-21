package com.one.touring.hotel;

import java.time.LocalDate;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.one.touring.reserve.user.ReserveDao;
import com.one.touring.reserve.user.ReserveService;
import com.one.touring.reserve.user.ReserveVo;

@Service
public class HotelService {
	@Autowired
	HotelDao hotelDao;
	
	@Autowired
	ReserveDao reserveDao;

    @Autowired
    private HotelUploadFileService uploadFileService;

    @Autowired
    private ReserveService reserveService;
    
  //좋아요
    public boolean isLiked(int uno, int hno) {
        return hotelDao.existsByUnoAndHno(uno, hno);
    }

    @Transactional
    public void addLike(int uno, int hno) {
        hotelDao.insertLike(uno, hno);
        hotelDao.increaseLike(hno);
    }

    @Transactional
    public void cancelLike(int uno, int hno) {
        hotelDao.deleteLike(uno, hno);
        hotelDao.decreaseLike(hno);
    }
    
    // 호텔 검색 + 체크인/체크아웃 필터
    public List<HotelVo> searchHotelOk(String hname, Integer hcno, String hregion, Integer minPrice, Integer maxPrice,
            String checkin, String checkout) {

		// DAO에서 검색 조건 적용
		List<HotelVo> list = hotelDao.searchHotel(hname, hcno, hregion, minPrice, maxPrice);
		
		// 예약 가능 여부 필터 (체크인/체크아웃 입력 있을 때만)
		if (checkin != null && !checkin.isEmpty() && checkout != null && !checkout.isEmpty()) {
			list.removeIf(hotel -> !reserveService.isHotelAvailable(hotel.getHno(), checkin, checkout));
		}
		return list;
	}
    
    public boolean isHotelAvailable(int hno, String checkin, String checkout) {
        int totalRooms = reserveDao.getHotelPeople(hno);
        List<ReserveVo> overlapping = reserveDao.selectOverlappingReserves(hno, checkin, checkout);
        return overlapping.size() < totalRooms; // 남은 방이 1개 이상이면 예약 가능
    }
    
    public boolean hasFutureReservations(int hno) {
        LocalDate today = LocalDate.now();
        int count = hotelDao.countReservationsAfterDate(hno, today);
        return count > 0;
    }
    
    // hotel 삭제 (예약 내역 포함)
    @Transactional
    public void deleteHotel(int hno) {
    	// 1. 좋아요 내역 삭제
    	hotelDao.deleteLikesByHotel(hno);
    	// 2. 리뷰 내역 삭제
    	hotelDao.deleteReviewsByHotel(hno);
        // 3. 예약 내역 삭제
    	hotelDao.deleteReservationsByHotel(hno);
        // 4. 사진 삭제
        List<HotelFileVo> fileDataList = hotelDao.getFileData(hno);
        if (fileDataList != null && !fileDataList.isEmpty()) {
            for (HotelFileVo fileData : fileDataList) {
                uploadFileService.delete(fileData.getHfilename());
            }
            hotelDao.deleteFileData(hno);
        }
        // 3. 호텔 삭제
        hotelDao.deleteHotel(hno);
    }
    
    // hotel 수정 + 파일 수정
    public void updateHotel(HotelVo hotelVo, List<HotelFileVo> fileDataList, boolean fileUp) {
        hotelDao.updateHotel(hotelVo);
        if (fileUp && fileDataList != null && !fileDataList.isEmpty()) {
            for (HotelFileVo file : fileDataList) {
                file.setHno(hotelVo.getHno());
                hotelDao.insertHotelFile(file);
            }
        }
    }

    // hotel 개별 파일 삭제
    public void fileRemove(int hfno) {
        HotelFileVo fileData = hotelDao.getFileDataByHfno(hfno);
        if (fileData != null) {
            uploadFileService.delete(fileData.getHfilename());
            hotelDao.removeFileData(hfno);
        }
    }
    
    // hotel 등록
    @Transactional
    public int insertHotel(HotelVo hotelVo) {
        return hotelDao.insertHotel(hotelVo);
    }

    // hotel 파일 등록
    public void insertHotelFiles(List<HotelFileVo> fileList) {
        for (HotelFileVo fileVo : fileList) {
            hotelDao.insertHotelFile(fileVo);
        }
    }
	
    // hotel 사진 불러오기
	public List<HotelFileVo> getFileData(int hno) {
		return hotelDao.getFileData(hno);
	}
	
	// hotel 디테일
	public HotelVo detailHotel(int hno) {
		HotelVo hotelVo=hotelDao.detailHotel(hno);
		List<HotelFileVo> fildDataList=hotelDao.getFileData(hno);
		hotelVo.setFileDataList(fildDataList);
		return hotelVo;
	}
	
	// hotel 리스트
	public List<HotelVo> selectListHotel(){
		return hotelDao.selectListHotel();
	}
}
