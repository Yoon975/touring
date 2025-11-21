package com.one.touring.tour;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;


@Repository
public class TourDao {
	@Autowired
	JdbcTemplate jdbcTemplate;

	// 키워드 + 카테고리 복합 검색
	public List<TourVo> searchTour(Integer tcno, String tregion, String keyword) {
	    StringBuilder sql = new StringBuilder(
	        "select t.*, f.tfilename as mainFile from tour t " +
	        "left join (select tno, tfilename from tourfile where tfno in " +
	        "(select min(tfno) from tourfile group by tno)) f on t.tno = f.tno where 1=1");
	    List<Object> params = new ArrayList<>();

	    if (tcno != null) {
	        sql.append(" and t.tcno = ?");
	        params.add(tcno);
	    }

        if (tregion != null && !tregion.isEmpty()) {
            sql.append(" and t.tregion = ?");
            params.add(tregion);
        }

	    if (keyword != null && !keyword.trim().isEmpty()) {
	        sql.append(" and (t.tname like ? or t.taddress like ?)");
	        String kw = "%" + keyword.trim() + "%";
	        params.add(kw);
	        params.add(kw);
	    }

	    sql.append(" order by t.tregdate desc");
	    return jdbcTemplate.query(sql.toString(), new BeanPropertyRowMapper<>(TourVo.class), params.toArray());
	}
	
	// tour 파일 삭제
	public int deleteFileData(int tno) {
	      String sql="delete from tourfile where tno=?";
	      int result=0;
	      try {
	         result=jdbcTemplate.update(sql,tno);
	      }catch(Exception e) {
	         e.printStackTrace();
	      }
	      return result;      
	   }
	
    // tour 삭제
	public int deleteTour(int tno) {
	      String sql="delete from tour where tno=?";
	      int result=0;
	      try {
	         result=jdbcTemplate.update(sql,tno);
	      }catch(Exception e) {
	         e.printStackTrace();
	      }
	      return result;   
	   }
	
    // tour 수정
    public int updateTour(TourVo tourVo) {
        String sql="update tour set tname=?, tdescription=?, taddress=?, tcno=?, tregion=?  where tno=?";
        int result=0;
        try {
            result = jdbcTemplate.update(sql, 
                tourVo.getTname(),
                tourVo.getTdescription(),
                tourVo.getTaddress(),
                tourVo.getTcno(),
                tourVo.getTregion(),
                tourVo.getTno()
            );
        }catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    // tour 단일 파일 삭제
    public int removeFileData(int tfno) {
        String sql="delete from tourfile where tfno=?";
        return jdbcTemplate.update(sql, tfno);
    }
	
    // tfno 기준 파일 정보 조회 (서버 파일 삭제용)
    public TourFileVo getFileDataByTfno(int tfno) {
        String sql = "select * from tourfile where tfno=?";
        RowMapper<TourFileVo> rowMapper = BeanPropertyRowMapper.newInstance(TourFileVo.class);
        try {
            return jdbcTemplate.queryForObject(sql, rowMapper, tfno);
        } catch (Exception e) {
            return null; // 없으면 null 반환
        }
    }
    
    // tour 등록
	public int insertTour(TourVo tourVo) {
		System.out.println(tourVo);
	    String sql = "insert into tour (tname, tdescription, taddress, tregdate, tcno, tregion) values (?, ?, ?, now(), ?, ?)";
	    KeyHolder keyHolder = new GeneratedKeyHolder();
	    jdbcTemplate.update(connection -> {
	        PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
	        ps.setString(1, tourVo.getTname());
	        ps.setString(2, tourVo.getTdescription());
	        ps.setString(3, tourVo.getTaddress());
	        ps.setInt(4, tourVo.getTcno());
	        ps.setString(5, tourVo.getTregion());
	        return ps;
	    }, keyHolder);

	    int tno = keyHolder.getKey().intValue();
	    tourVo.setTno(tno);
	    return tno;
	}
    // tour 파일 등록
    public int insertTourFile(TourFileVo fileVo) {
        String sql = "insert into tourfile (tno, toriginal, tfilename, size) values (?, ?, ?, ?)";
        int result=jdbcTemplate.update(sql, fileVo.getTno(), fileVo.getToriginal(),
        		fileVo.getTfilename(), fileVo.getSize());
        return result;
    }
	
    // tour 파일 불러오기
	public List<TourFileVo> getFileData(int tno) {
		String sql="select * from tourfile where tno=?";
		RowMapper<TourFileVo> rowMapper=
				BeanPropertyRowMapper.newInstance(TourFileVo.class);
		return jdbcTemplate.query(sql, rowMapper, tno);
	}
	
	//tour 조회수
	public int updateTourHit(int tno) {
		String sql="update tour set thit=thit+1 where tno=?";
		int result=0;
		try {
			result=jdbcTemplate.update(sql, tno);
		}catch(Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	// tour 디테일
	public TourVo detailTour(int tno) {
		String sql="select * from tour where tno=?";
		RowMapper<TourVo> rowMapper=
				BeanPropertyRowMapper.newInstance(TourVo.class);
		TourVo result=jdbcTemplate.queryForObject(sql, rowMapper, tno);
		return result;
	}
	
	// tour 리스트
	public List<TourVo> selectListTour() {
	    String sql = "select t.*, f.tfilename as mainFile from tour t "
	               + "left join (select tno, tfilename from tourfile where tfno in "
	               + "(select min(tfno) from tourfile group by tno)) f "
	               + "on t.tno = f.tno order by t.tregdate desc";
	    RowMapper<TourVo> rowMapper = BeanPropertyRowMapper.newInstance(TourVo.class);
	    return jdbcTemplate.query(sql, rowMapper);
	}
	
//	public List<TourVo> selectListTour(){
//		String sql="select * from tour order by tregdate desc";
//		RowMapper<TourVo> rowMapper=
//			BeanPropertyRowMapper.newInstance(TourVo.class);
//		List<TourVo> result=jdbcTemplate.query(sql,rowMapper);
//		return result;
//	}
}
