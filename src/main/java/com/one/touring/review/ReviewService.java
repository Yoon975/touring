package com.one.touring.review;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ReviewService {

    @Autowired
    private ReviewDao reviewDao;

    public List<ReviewVo> AllReviews() {
        return reviewDao.AllReviews();
    }

    public List<ReviewVo> searchReviews(String category, String value) {
        return reviewDao.searchReviews(category, value);
    }

    // 리뷰 삭제
    public void deleteReview(int rno) {
        reviewDao.deleteReview(rno);
    }
    
    // 리뷰 업데이트
    public void updateReview(ReviewVo reviewVo) {
        reviewDao.updateReview(reviewVo);
    }

    // 리뷰 상세보기
    public ReviewVo detailReview(int rno) {
        return reviewDao.detailReview(rno);
    }
    
    // 나의 리뷰 보기
    public List<ReviewVo> myReviewList(int uno) {
    	return reviewDao.myReviewList(uno);
    }
    
    // 리뷰 존재 여부
    public boolean reviewsByDno(int dno) {
        return reviewDao.reviewsByDno(dno);
    }
    
    public void insertReview(ReviewVo reviewVo) {
        reviewDao.insertReview(reviewVo);
    }
    
    public List<ReviewVo> getReviewsByHotelHno(int hno) {
        return reviewDao.getReviewsByHotelHno(hno);
    }
}
