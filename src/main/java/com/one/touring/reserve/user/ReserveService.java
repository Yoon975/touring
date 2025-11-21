package com.one.touring.reserve.user;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.one.touring.hotel.HotelVo;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Service
public class ReserveService {

    @Autowired
    private ReserveDao reserveDao;

    // 호텔 남은 방 체크 ( hotel에서 사용)
    public boolean isHotelAvailable(int hno, String checkin, String checkout) {
        int totalRooms = reserveDao.getHotelPeople(hno);
        List<ReserveVo> overlapping = reserveDao.selectOverlappingReserves(hno, checkin, checkout);
        return overlapping.size() < totalRooms; // 남은 방 1개 이상이면 예약 가능
    }
    
    // ------------------- 예약 목록 조회 -------------------
    public List<ReserveVo> getReserveList(int uno) {
        return reserveDao.selectReserveList(uno);
    }

    // ------------------- 예약 상세 조회 -------------------
    public ReserveVo getReserveDetail(int dno) {
        return reserveDao.selectReserveDetail(dno);
    }

    // ------------------- 호텔 상세 조회 -------------------
    public HotelVo detailHotel(int hno) {
        return reserveDao.detailHotel(hno);
    }

 // ------------------- 예약 등록 -------------------
    @Transactional
    public void insertReserve(ReserveVo reserve) {

        // SQL 기반 예약 가능 여부 체크
        boolean available = reserveDao.isHotelAvailableBySQL(
                reserve.getHno(),
                reserve.getCheckin(),
                reserve.getCheckout()
        );

        if (!available) {
            throw new RuntimeException("예약 불가: 선택한 기간에 남은 방이 없습니다.");
        }

        // 예약 등록
        reserveDao.insertReserve(reserve);
    }

 // ------------------- 예약 수정 -------------------
    @Transactional
    public void updateReserve(ReserveVo reserve) {

        // SQL 기반 예약 가능 여부 체크 (자신 제외)
        boolean available = reserveDao.isHotelAvailableBySQL(
                reserve.getHno(),
                reserve.getCheckin(),
                reserve.getCheckout()
        );

        if (!available) {
            throw new RuntimeException("예약 불가: 선택한 기간에 남은 방이 없습니다.");
        }

        reserveDao.updateReserve(reserve);
    }

    //예약 취소
    public void cancelReserve(int dno) {
        reserveDao.cancelReserve(dno);
    }

    //지난 예약 삭제
    public void deletePastReserves() {
        String today = LocalDate.now().toString();
        reserveDao.deletePastReserves(today);
    }
 // 호텔별 예약 목록 조회 (자신 예약 제외 가능)
    public List<String> getBookedDates(int hno, Integer excludeDno) {
        List<ReserveVo> reserves;
        if (excludeDno != null) {
            // 수정 시 자신 예약 제외
            reserves = reserveDao.selectReservesByHotelExcludingDno(hno, excludeDno);
        } else {
            // 신규 예약
            reserves = reserveDao.selectReservesByHotel(hno);
        }

        List<String> bookedDates = new ArrayList<>();
        for (ReserveVo r : reserves) {
            LocalDate start = LocalDate.parse(r.getCheckin());
            LocalDate end = LocalDate.parse(r.getCheckout());

            for (LocalDate date = start; !date.isAfter(end); date = date.plusDays(1)) {
                bookedDates.add(date.toString());
            }
        }
        return bookedDates;
    }
    
    // 기존 hno만 받는 호출용
    public List<String> getBookedDates(int hno) {
        return getBookedDates(hno, null); // excludeDno=null → 자신 예약 제외 없음
    }

}
