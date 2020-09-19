package com.luyi.bean;

public class Department {
    private Integer nid;

    private String name;

    
    
    public Department() {
		super();
	}

	public Department(Integer nid, String name) {
		super();
		this.nid = nid;
		this.name = name;
	}

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

	@Override
	public String toString() {
		return "Department [nid=" + nid + ", name=" + name + "]";
	}
    
}