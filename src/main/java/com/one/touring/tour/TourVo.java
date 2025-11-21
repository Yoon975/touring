package com.one.touring.tour;

import java.util.List;
import lombok.Data;

@Data
public class TourVo {
	private int tno;
	private String tname;
	private String tdescription;
	private String taddress;
	private int thit;
	private String tregdate;
	private int tcno;
	private String tregion;
	
	private List<TourFileVo> fileDataList;
	
	private String mainFile;  // selectList에서 대표 사진용

	public String getMainFile() { return mainFile; }
	public void setMainFile(String mainFile) { this.mainFile = mainFile; }

}
