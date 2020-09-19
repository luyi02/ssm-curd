package com.luyi.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.luyi.bean.Employee;
import com.luyi.bean.EmployeeExample;
import com.luyi.bean.EmployeeExample.Criteria;
import com.luyi.dao.EmployeeMapper;

@Service
public class EmployeeService {

	@Autowired
	private EmployeeMapper employeeMapper;
	
	public List<Employee> getAll() {
		return employeeMapper.selectByExampleWithDept(null);
	}

	public void saveEmpl(Employee employee) {
		employeeMapper.insert(employee);
	}

	/**
	 * 校验姓名是否可用
	 * @param empName
	 * @return true代表姓名可用，false代表姓名不可用
	 */
	public boolean checkUser(String empName) {
		
		EmployeeExample example = new EmployeeExample();
		Criteria criteria = example.createCriteria();
		criteria.andNameEqualTo(empName);
		long count = employeeMapper.countByExample(example);
		return count == 0;
	}

	/**
	 * 按照员工id查询员工
	 * @param id
	 * @return
	 */
	public Employee getEmpl(Integer nid) {
		Employee employee = employeeMapper.selectByPrimaryKey(nid);
		return employee;
	}

	/**
	 * 修改员工方法
	 * @param employee
	 */
	public void updateEmpl(Employee employee) {
		employeeMapper.updateByPrimaryKeySelective(employee);
	}

	public void deleteEmpl(Integer nid) {
		employeeMapper.deleteByPrimaryKey(nid);
	}

	public void deleteBatch(List<Integer> del_nids) {
		EmployeeExample example = new EmployeeExample();
		Criteria criteria = example.createCriteria();
		
		//delete from xxx where nid in xxx
		criteria.andNidIn(del_nids);
		employeeMapper.deleteByExample(example);
	}

}
