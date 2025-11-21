package com.one.touring.reserve.user;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import com.one.touring.hotel.HotelVo;

@Repository
public class ReserveDao {

    @Autowired
    private JdbcTemplate jdbcTemplate;
    
 // 특정 호텔, 특정 기간 예약 가능 여부 체크 (SQL 단일 쿼리)
    public boolean isHotelAvailableBySQL(int hno, String checkin, String checkout) {
        String sql = 
            "WITH RECURSIVE dates AS ( " +
            "    SELECT CAST(? AS DATE) AS dt " +
            "    UNION ALL " +
            "    SELECT dt + INTERVAL 1 DAY " +
            "    FROM dates " +
            "    WHERE dt + INTERVAL 1 DAY < ? " +
            ") " +
            "SELECT COUNT(*) AS unavailable_days " +
            "FROM dates d " +
            "LEFT JOIN deal r " +
            "    ON r.hno = ? " +
            "   AND d.dt >= r.checkin " +
            "   AND d.dt < r.checkout " +
            "GROUP BY d.dt " +
            "HAVING COUNT(r.dno) >= (SELECT hmax FROM hotel WHERE hno = ?)";

        List<Integer> result = jdbcTemplate.query(sql,
                (rs, rowNum) -> rs.getInt("unavailable_days"),
                checkin, checkout, hno, hno);

        return result.isEmpty();
    }
    
//  호텔 상세 조회
	public HotelVo detailHotel(int hno) {
		String sql="select * from hotel where hno=?";
		RowMapper<HotelVo> rowMapper=
				BeanPropertyRowMapper.newInstance(HotelVo.class);
		HotelVo result=jdbcTemplate.queryForObject(sql, rowMapper, hno);
		return result;
	}
    
    // 예약 목록 조회
    public List<ReserveVo> selectReserveList(int uno) {
        String sql = "SELECT d.*, h.hname as hotelName " +
                     "FROM deal d JOIN hotel h ON d.hno=h.hno " +
                     "WHERE d.uno=? order by d.checkin desc";
        RowMapper<ReserveVo> rowMapper = new BeanPropertyRowMapper<>(ReserveVo.class);
        return jdbcTemplate.query(sql, rowMapper, uno);
    }
    
    // 예약 상세 조회
    public ReserveVo selectReserveDetail(int dno) {
        String sql = "SELECT d.*, h.hname as hotelName " +
                     "FROM deal d JOIN hotel h ON d.hno=h.hno " +
                     "WHERE d.dno=?";

        RowMapper<ReserveVo> rowMapper = new BeanPropertyRowMapper<>(ReserveVo.class);
        return jdbcTemplate.queryForObject(sql, rowMapper, dno);
    }


    // 예약 등록
    public int insertReserve(ReserveVo reserve) {
    	System.out.println(reserve);
    	
        // 예약 가능 여부 체크
        if (!isHotelAvailableBySQL(reserve.getHno(), reserve.getCheckin(), reserve.getCheckout())) {
            System.out.println("예약 불가: 남은 방이 없습니다.");
            return 0;
        }
        String sql = "INSERT INTO deal (uno, hno, pno, checkin, checkout, dprice, dregdate) VALUES (?, ?, ?, ?, ?, ?, NOW())";

        return jdbcTemplate.update(sql,
                reserve.getUno(),
                reserve.getHno(),
                reserve.getPno(),
                reserve.getCheckin(),
                reserve.getCheckout(),
                reserve.getDprice());
    }

    // 예약 수정
    public int updateReserve(ReserveVo Reserve) {
        String sql = "UPDATE deal SET checkin=?, checkout=? WHERE dno=?";
        return jdbcTemplate.update(sql,
                Reserve.getCheckin(),
                Reserve.getCheckout(),
                Reserve.getDno());
    }

    // 예약 삭제
    public int cancelReserve(int dno) {
        String sql = "DELETE FROM deal WHERE dno=?";
        return jdbcTemplate.update(sql, dno);
    }
 // 특정 호텔, 특정 기간 겹치는 예약 리스트 (insert용)
    public List<ReserveVo> selectOverlappingReserves(int hno, String checkin, String checkout) {
        String sql = "SELECT * FROM deal WHERE hno=? AND NOT (checkout <= ? OR checkin >= ?)";
        RowMapper<ReserveVo> rowMapper = new BeanPropertyRowMapper<>(ReserveVo.class);
        return jdbcTemplate.query(sql, rowMapper, hno, checkin, checkout);
    }

    // 특정 호텔, 특정 기간 겹치는 예약 리스트 (update용, 자신 제외)
    public List<ReserveVo> selectOverlappingReservesExcludingDno(int hno, String checkin, String checkout, int dno) {
        String sql = "SELECT * FROM deal WHERE hno=? AND dno<>? AND NOT (checkout <= ? OR checkin >= ?)";
        RowMapper<ReserveVo> rowMapper = new BeanPropertyRowMapper<>(ReserveVo.class);
        return jdbcTemplate.query(sql, rowMapper, hno, dno, checkin, checkout);
    }
    
    // 호텔 방 개수 조회
    public int getHotelPeople(int hno) {
        String sql = "SELECT hmax FROM hotel WHERE hno=?";
        return jdbcTemplate.queryForObject(sql, Integer.class, hno);
    }

    // 지난 예약 삭제
    public void deletePastReserves(String today) {
        String sql = "DELETE FROM deal WHERE checkout < ?";
        jdbcTemplate.update(sql, today);
    }
    //호텔별 예약 목록 조회
    public List<ReserveVo> selectReservesByHotel(int hno) {
        String sql = "SELECT checkin, checkout FROM deal WHERE hno=?";
        RowMapper<ReserveVo> rowMapper = new BeanPropertyRowMapper<>(ReserveVo.class);
        return jdbcTemplate.query(sql, rowMapper, hno);
    }
    
    // 호텔별 예약 목록 조회 (자신 예약 제외)
    public List<ReserveVo> selectReservesByHotelExcludingDno(int hno, int dno) {
        String sql = "SELECT checkin, checkout FROM deal WHERE hno=? AND dno<>?";
        RowMapper<ReserveVo> rowMapper = new BeanPropertyRowMapper<>(ReserveVo.class);
        return jdbcTemplate.query(sql, rowMapper, hno, dno);
    }
    
}
