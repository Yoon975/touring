package com.one.touring.user;

import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Repository;

import com.one.touring.hotel.HotelVo;

@Repository
public class UserDao {
	@Autowired
	JdbcTemplate jdbcTemplate;
	@Autowired
	BCryptPasswordEncoder bCryptPasswordEncoder;
	
	// 좋아요한 호텔 목록 조회
	   public List<HotelVo> getLikedHotels(int uno) {
	       String sql = 
	           "SELECT h.hno, h.hname, h.hdescription, h.haddress, h.hprice, h.hreserveOk, " +
	           "h.hmax, h.hlike, h.hregdate, h.hcno, h.hregion, f.hfilename AS mainFile " +
	           "FROM hotel h " +
	           "JOIN `like` l ON h.hno = l.hno " +
	           "LEFT JOIN ( " +
	           "    SELECT hfno, hno, hfilename " +
	           "    FROM hotelfile " +
	           "    WHERE hfno IN (SELECT MIN(hfno) FROM hotelfile GROUP BY hno) " +
	           ") f ON h.hno = f.hno " +
	           "WHERE l.uno = ? " +
	           "ORDER BY h.hregdate DESC";

	       return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(HotelVo.class), uno);
	   }
	
	   //  로그인
	   public UserVo loginOk(String id, String pw) {
	 	  String sql = "select * from user where id=?";
	 	  RowMapper<UserVo> rowMapper = BeanPropertyRowMapper.newInstance(UserVo.class);
	 	  try {
	 		  UserVo vo = jdbcTemplate.queryForObject(sql, rowMapper, id);
	 		  if (vo != null && bCryptPasswordEncoder.matches(pw, vo.getPw())) {
	 			  return vo;
	 		  } else {
	 			  return null;
	 		  }
	 	  } catch (Exception e) {
	 		  return null;
	 	  }
	   }
	   //  회원가입
	public int insert(UserVo vo) {
		String sql="insert into user (id,pw,name,email,phone,regdate) values (?,?,?,?,?,now())";
		int result=jdbcTemplate.update(sql,
				vo.getId(),
				bCryptPasswordEncoder.encode(vo.getPw()),
				vo.getName(),
				vo.getEmail(),
				vo.getPhone());
		return result;
	}
//  회원 목록
	public List<UserVo> selectAll(){
		String sql="select * from user where name!='(알수없음)'";
		RowMapper<UserVo> rowMapper=BeanPropertyRowMapper.newInstance(UserVo.class);
		List<UserVo> userList=jdbcTemplate.query(sql, rowMapper);
		return userList;
	}
//  회원번호로 조회
	public UserVo select_uno(int uno) {
		String sql="select * from user where uno=?";
		RowMapper<UserVo> rowMapper=BeanPropertyRowMapper.newInstance(UserVo.class);
		UserVo user=jdbcTemplate.queryForObject(sql, rowMapper,uno);
		return user;
	}
//  수정
	public int update(UserVo vo) {
		String sql="update user set name=?,email=?,phone=? where uno=?";
		int result=jdbcTemplate.update(sql,
				vo.getName(),
				vo.getEmail(),
				vo.getPhone(),
				vo.getUno());
		return result;
	}
//  탈퇴
	public int delete(int uno) {
		String sql="update user set pw=?,name='(알수없음)',email='탈퇴함',phone='탈퇴함',regdate='탈퇴함' where uno=?";
		String dummyPw = UUID.randomUUID().toString();
		int result=jdbcTemplate.update(sql,dummyPw,uno);
		return result;
	}
//	id 중복체크
	public boolean idCk(String id) {
		String sql="select count(*) from user where id=?";
		int result=jdbcTemplate.queryForObject(sql, Integer.class,id);
		if(result==1) {
			return true;
		}else if(result==0) {
			return false;
		}
		return true;
	}
//	관리자 권한 신청
	public void adminTry(int uno) {
		String sql="update user set admin='2' where uno=?";
		jdbcTemplate.update(sql,uno);
	}
//	관리자 권한 승인
	public void adminTryOk(int uno) {
		String sql="update user set admin='1' where uno=?";
		jdbcTemplate.update(sql,uno);
	}
// 관리자 권한 취소 / 거부
	public void adminTryNo(int uno) {
		String sql="update user set admin='0' where uno=?";
		jdbcTemplate.update(sql,uno);
	}
//	비번 확인
	public boolean pwCheck(String id,String pw) {
		String sql="select pw from user where id=?";
		String nowPw=jdbcTemplate.queryForObject(sql,String.class,id);
		if (!bCryptPasswordEncoder.matches(pw,nowPw)) {
			return false;
		}
		return true;
	}
//	비번 변경
	public void updatePw(String id, String pw) {
		String sql="update user set pw=? where id=?";
		jdbcTemplate.update(sql,bCryptPasswordEncoder.encode(pw),id);
	}
}
