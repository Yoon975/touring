package com.one.touring.hotel;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import com.one.touring.reserve.user.ReserveVo;

@Repository
public class HotelDao {
	@Autowired
	JdbcTemplate jdbcTemplate;
	
	// 좋아요 여부 확인
	public boolean existsByUnoAndHno(int uno, int hno) {
	    String sql = "SELECT COUNT(*) FROM `like` WHERE uno = ? AND hno = ?";
	    Integer count = jdbcTemplate.queryForObject(sql, Integer.class, uno, hno);
	    return count != null && count > 0;
	}

	// 좋아요 등록
	public int insertLike(int uno, int hno) {
	    String sql = "INSERT INTO `like` (uno, hno) VALUES (?, ?)";
	    return jdbcTemplate.update(sql, uno, hno);
	}

	// 좋아요 취소
	public int deleteLike(int uno, int hno) {
	    String sql = "DELETE FROM `like` WHERE uno = ? AND hno = ?";
	    return jdbcTemplate.update(sql, uno, hno);
	}

	// 좋아요 수 증가
	public int increaseLike(int hno) {
	    String sql = "UPDATE hotel SET hlike = hlike + 1 WHERE hno = ?";
	    return jdbcTemplate.update(sql, hno);
	}

	// 좋아요 수 감소
	public int decreaseLike(int hno) {
	    String sql = "UPDATE hotel SET hlike = CASE WHEN hlike > 0 THEN hlike - 1 ELSE 0 END WHERE hno = ?";
	    return jdbcTemplate.update(sql, hno);
	}

	
    // 특정 호텔, 특정 기간 겹치는 예약 리스트
    public List<ReserveVo> selectOverlappingReserves(int hno, String checkin, String checkout) {
        String sql = "SELECT * FROM deal WHERE hno=? AND NOT (checkout <= ? OR checkin >= ?)";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(ReserveVo.class),
                hno, checkin, checkout);
    }
    
    // 호텔 방 개수
    public int getHotelPeople(int hno) {
        String sql = "SELECT hmax FROM hotel WHERE hno=?";
        return jdbcTemplate.queryForObject(sql, Integer.class, hno);
    }
	
    public List<HotelVo> searchHotel(String hname, Integer hcno, String hregion, Integer minPrice, Integer maxPrice) {
        StringBuilder sql = new StringBuilder(
            "select h.*, f.hfilename as mainfile from hotel h " +
            "left join (select hno, hfilename from hotelfile where hfno in " +
            "(select min(hfno) from hotelfile group by hno)) f on h.hno = f.hno " +
            "where 1=1");

        List<Object> params = new ArrayList<>();

        if (hname != null && !hname.trim().isEmpty()) {
            sql.append(" and h.hname like ?");
            params.add("%" + hname.trim() + "%");
        }
        if (hcno != null) {
            sql.append(" and h.hcno = ?");
            params.add(hcno);
        }
        if (minPrice != null) {
            sql.append(" and cast(h.hprice as unsigned) >= ?");
            params.add(minPrice);
        }
        if (maxPrice != null) {
            sql.append(" and cast(h.hprice as unsigned) <= ?");
            params.add(maxPrice);
        }

        if (hregion != null && !hregion.isEmpty()) {
            sql.append(" and h.hregion = ?");
            params.add(hregion);
        }
        
        sql.append(" order by h.hregdate desc");

        return jdbcTemplate.query(sql.toString(), (rs, rowNum) -> {
            HotelVo hotel = new HotelVo();
            hotel.setHno(rs.getInt("hno"));
            hotel.setHname(rs.getString("hname"));
            hotel.setHaddress(rs.getString("haddress"));
            hotel.setHprice(rs.getString("hprice"));
            hotel.setHmax(rs.getInt("hmax"));
            hotel.setHlike(rs.getInt("hlike"));
            hotel.setHcno(rs.getInt("hcno"));
            hotel.setHregion(rs.getString("hregion"));
            hotel.setMainFile(rs.getString("mainfile"));
            return hotel;
        }, params.toArray());
    }
   
	// 체크아웃 지나지 않은 예약 카운트
	public int countReservationsAfterDate(int hno, LocalDate today) {
	    String sql = "SELECT COUNT(*) FROM deal WHERE hno=? AND checkout > ?";
	    return jdbcTemplate.queryForObject(sql, Integer.class, hno, today);
	}
	
	// 호텔 관련 예약 삭제
	public void deleteLikesByHotel(int hno) {
	    String sql = "DELETE FROM `like` WHERE hno=?";
	    jdbcTemplate.update(sql, hno);
	}
	
	// 호텔 리뷰 삭제
	public void deleteReviewsByHotel(int hno) {
	    String sql = "delete r from review r join deal d on r.dno = d.dno where d.hno = ?";
	    jdbcTemplate.update(sql, hno);
	}
	
	// 호텔 관련 예약 삭제
	public void deleteReservationsByHotel(int hno) {
	    String sql = "DELETE FROM deal WHERE hno=?";
	    jdbcTemplate.update(sql, hno);
	}
	
	// hotel 파일 삭제
	public int deleteFileData(int hno) {
	      String sql="delete from hotelfile where hno=?";
	      int result=0;
	      try {
	         result=jdbcTemplate.update(sql, hno);
	      }catch(Exception e) {
	         e.printStackTrace();
	      }
	      return result;      
	   }
	
    // hotel 삭제
	public int deleteHotel(int hno) {
	      String sql="delete from hotel where hno=?";
	      int result=0;
	      try {
	         result=jdbcTemplate.update(sql, hno);
	      }catch(Exception e) {
	         e.printStackTrace();
	      }
	      return result;   
	   }
	
    // hotel 수정
    public int updateHotel(HotelVo hotelVo) {
        String sql="update hotel set hname=?, hdescription=?, haddress=?, "
        		+ "hprice=?, hreserveOk=?, hmax=?, hcno=?, hregion=? where hno=?";
        int result=0;
        try {
            result = jdbcTemplate.update(sql, 
                hotelVo.getHname(),
                hotelVo.getHdescription(),
                hotelVo.getHaddress(),
                hotelVo.getHprice(),
                hotelVo.getHreserveOk(),
                hotelVo.getHmax(),
                hotelVo.getHcno(),
                hotelVo.getHregion(),
                hotelVo.getHno()
            );
        }catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    // hotel 단일 파일 삭제
    public int removeFileData(int hfno) {
        String sql="delete from hotelfile where hfno=?";
        return jdbcTemplate.update(sql, hfno);
    }
	
    // hotel 기준 파일 정보 조회 (서버 파일 삭제용)
    public HotelFileVo getFileDataByHfno(int hfno) {
        String sql = "select * from hotelfile where hfno=?";
        RowMapper<HotelFileVo> rowMapper = BeanPropertyRowMapper.newInstance(HotelFileVo.class);
        try {
            return jdbcTemplate.queryForObject(sql, rowMapper, hfno);
        } catch (Exception e) {
            return null; // 없으면 null 반환
        }
    }
    
    // hotel 등록
	public int insertHotel(HotelVo hotelVo) {
	    String sql = "insert into hotel (hname, hdescription, haddress, hprice, hreserveOk, hmax, "
	    		+ "hregdate, hcno, hregion) values (?, ?, ?, ?, ?, ?, now(), ?,?)";
	    KeyHolder keyHolder = new GeneratedKeyHolder();
	    jdbcTemplate.update(connection -> {
	        PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
	        ps.setString(1, hotelVo.getHname());
	        ps.setString(2, hotelVo.getHdescription());
	        ps.setString(3, hotelVo.getHaddress());
	        ps.setString(4, hotelVo.getHprice());
	        ps.setString(5, hotelVo.getHreserveOk());
	        ps.setInt(6, hotelVo.getHmax());
	        ps.setInt(7, hotelVo.getHcno());
	        ps.setString(8, hotelVo.getHregion());
	        return ps;
	    }, keyHolder);

	    int hno = keyHolder.getKey().intValue();
	    hotelVo.setHno(hno);
	    return hno;
	}

    // hotel 파일 등록
    public int insertHotelFile(HotelFileVo fileVo) {
        String sql = "insert into hotelfile (hno, horiginal, hfilename, size) values (?, ?, ?, ?)";
        int result=jdbcTemplate.update(sql, fileVo.getHno(), fileVo.getHoriginal(),
        		fileVo.getHfilename(), fileVo.getSize());
        return result;
    }
	
    // hotel 파일 불러오기
	public List<HotelFileVo> getFileData(int hno) {
		String sql="select * from hotelfile where hno=?";
		RowMapper<HotelFileVo> rowMapper=
				BeanPropertyRowMapper.newInstance(HotelFileVo.class);
		return jdbcTemplate.query(sql, rowMapper, hno);
	}
	
	// hotel 디테일
	public HotelVo detailHotel(int hno) {
		String sql="select * from hotel where hno=?";
		RowMapper<HotelVo> rowMapper=
				BeanPropertyRowMapper.newInstance(HotelVo.class);
		HotelVo result=jdbcTemplate.queryForObject(sql, rowMapper, hno);
		return result;
	}

	// hotel 리스트
	public List<HotelVo> selectListHotel() {
	    String sql = "select h.*, f.hfilename as mainFile from hotel h "
	               + "left join (select hno, hfilename from hotelfile where hfno in "
	               + "(select min(hfno) from hotelfile group by hno)) f "
	               + "on h.hno = f.hno order by h.hregdate desc";
	    RowMapper<HotelVo> rowMapper = BeanPropertyRowMapper.newInstance(HotelVo.class);
	    return jdbcTemplate.query(sql, rowMapper);
	}
}
