package com.luyi.bean;

import javax.validation.constraints.Pattern;

public class Employee {
	
	public Employee(){
		
	}

	
	public Employee(Integer nid, String name, Integer dId) {
		super();
		this.nid = nid;
		this.name = name;
		this.dId = dId;
	}


	private Integer nid;

	//自定义JSR303校验规则
	@Pattern(regexp="(^[A-Za-z0-9]{6,16}$)|(^[\u4e00-\u9fa5]{2,6}$)", 
			message="姓名只能是6-16位英文字母和数字或者2-6位的中文组成（后端校验）")
    private String name;

    private Integer dId;
    
    private Department department;

    public Integer getNid() {
        return nid;
    }

    public void setNid(Integer nid) {
        this.nid = nid;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name == null ? null : name.trim();
    }

    public Integer getdId() {
        return dId;
    }

    public void setdId(Integer dId) {
        this.dId = dId;
    }

	public Department getDepartment() {
		return department;
	}

	public void setDepartment(Department department) {
		this.department = department;
	}

	@Override
	public String toString() {
		return "Employee [nid=" + nid + ", name=" + name + ", dId=" + dId
				+ ", department=" + department + "]";
	}
    
    
}