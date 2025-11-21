package com.one.touring.review;

import lombok.Data;

@Data
public class ReviewVo {
	private int rno;               // 리뷰 번호
	private int dno;               // 예약 번호
	private int uno;               // 회원 번호
	private String content;        // 리뷰 내용
	private int rating;            // 평점
	private String createdAt;

	private String hname;	// 호텔 이름 불러오기
	private int hno;	// 호텔 번호 불러오기
	private String name;	// 작성자 불러오기
	
    
	private boolean canUpdateReview;    // 리뷰 작성 가능 여부
}
