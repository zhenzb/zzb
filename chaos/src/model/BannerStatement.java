package model;

public class BannerStatement {
	private int id;
	private String space;
	private String method;
	private String statement;
	private String totalStatement;
	private int category;
	private int ispro;
	private int projectid;
	private String keeper;
	private String memo;
	private int sqlmode;
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getSpace() {
		return space;
	}

	public void setSpace(String space) {
		this.space = space;
	}

	public String getMethod() {
		return method;
	}

	public void setMethod(String method) {
		this.method = method;
	}

	public String getStatement() {
		return statement;
	}

	public void setStatement(String statement) {
		this.statement = statement;
	}

	public int getCategory() {
		return category;
	}

	public void setCategory(int category) {
		this.category = category;
	}

	public int getIspro() {
		return ispro;
	}

	public void setIspro(int ispro) {
		this.ispro = ispro;
	}

	public int getProjectid() {
		return projectid;
	}

	public void setProjectid(int projectid) {
		this.projectid = projectid;
	}

	public String getKeeper() {
		return keeper;
	}

	public void setKeeper(String keeper) {
		this.keeper = keeper;
	}

	public String getMemo() {
		return memo;
	}

	public void setMemo(String memo) {
		this.memo = memo;
	}

	public int getSqlmode() {
		return sqlmode;
	}

	public void setSqlmode(int sqlmode) {
		this.sqlmode = sqlmode;
	}

	public String getTotalStatement() {
		return totalStatement;
	}

	public void setTotalStatement(String totalStatement) {
		this.totalStatement = totalStatement;
	}
}