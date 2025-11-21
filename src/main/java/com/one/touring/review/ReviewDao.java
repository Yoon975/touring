package com.one.touring.review;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

@Repository
public class ReviewDao {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // 검색 (rno, uno, hno, hname, u.name)
    public List<ReviewVo> searchReviews(String category, String value) {
        String sql = "select r.*, h.hno, h.hname, u.name from review r " +
                     "join deal d on r.dno = d.dno join hotel h on d.hno = h.hno " +
                     "join user u on r.uno = u.uno ";
        List<Object> params = new ArrayList<>();
        if ("rno".equals(category)) {
            try {
                sql += " where r.rno = ?";
                params.add(Integer.parseInt(value));
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("리뷰번호는 숫자만 입력 가능합니다.");
            }
        } else if ("name".equals(category)) {
            sql += "where u.name like ?";
            params.add("%" + value + "%"); // 회원명 부분 검색
        } else if ("hname".equals(category)) {
            sql += "where h.hname like ?";
            params.add("%" + value + "%"); // 호텔명 부분 검색
        } else {
            throw new IllegalArgumentException("잘못된 검색 카테고리입니다: " + category);
        }
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(ReviewVo.class), params.toArray());
    }
    
    // 전체 리뷰 조회
    public List<ReviewVo> AllReviews() {
        String sql = "select r.*, h.hno, h.hname, u.name from review r " +
                     "join deal d on r.dno = d.dno join hotel h on d.hno = h.hno " +
                     "join user u on r.uno = u.uno order by r.rno desc";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(ReviewVo.class));
    }    
    
    // 리뷰 수정
    public void updateReview(ReviewVo reviewVo) {
        String sql = "update review set content = ?, rating = ?, created_at = CONCAT(CURDATE(), ' (수정됨)') where rno = ?";
        jdbcTemplate.update(sql, reviewVo.getContent(),
            reviewVo.getRating(), reviewVo.getRno()
        );
    }
    
    // 리뷰 상세보기
    public ReviewVo detailReview(int rno) {
        String sql = "select r.*, h.hno, h.hname, u.name from review r join deal d on r.dno=d.dno "
        			+ "join hotel h on d.hno = h.hno join user u on r.uno=u.uno where r.rno=?";
        RowMapper<ReviewVo> rowMapper = BeanPropertyRowMapper.newInstance(ReviewVo.class);
        return jdbcTemplate.queryForObject(sql, rowMapper, rno);
    }
    
    // 리뷰 삭제
    public void deleteReview(int rno) {
        String sql = "delete from review where rno = ?";
        jdbcTemplate.update(sql, rno);
    }
    
    // 나의 리뷰 보기
    public List<ReviewVo> myReviewList(int uno) {
        String sql = "select r.*, h.hno, h.hname from review r join deal d on r.dno=d.dno "
        		+ "join hotel h on d.hno=h.hno where r.uno=? order by r.rno desc";
        RowMapper<ReviewVo> rowMapper = BeanPropertyRowMapper.newInstance(ReviewVo.class);
        return jdbcTemplate.query(sql, rowMapper, uno);
    }
    
    // 리뷰 존재 여부
    public boolean reviewsByDno(int dno) {
        String sql = "select count(*) from review where dno=?";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, dno);
        return count != null && count > 0;
    }
    
    public void insertReview(ReviewVo reviewVo) {
        String sql = "insert into review (dno, uno, content, rating, created_at) " +
                "values (?, ?, ?, ?, CONCAT(CURDATE()))";
        jdbcTemplate.update(sql,
            reviewVo.getDno(),
            reviewVo.getUno(),
            reviewVo.getContent(),
            reviewVo.getRating()
        );
    }
    
    public List<ReviewVo> getReviewsByHotelHno(int hno) {
    	String sql = "select r.*, u.name from review r join deal d on "
    			+ "r.dno=d.dno join user u on r.uno=u.uno where d.hno=? order by r.rno";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(ReviewVo.class), hno);
    }
}