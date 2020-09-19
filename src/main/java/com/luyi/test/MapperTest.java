package com.luyi.test;

/**
 * 推荐Spring的项目就使用spring的单元测试，可以自动注入我们需要的组件
 * 导入SpringTest的依赖包
 * 有了SpringTest的依赖包就可以直接autowired要使用的组件即可
 */
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.luyi.bean.Department;
import com.luyi.bean.Employee;
import com.luyi.dao.DepartmentMapper;
import com.luyi.dao.EmployeeMapper;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations={"classpath:applicationContext.xml"})
public class MapperTest {
	@Autowired
	private DepartmentMapper departmentMapper;
	
	@Autowired
	private EmployeeMapper employeeMapper;
	
	@Autowired
	private SqlSession sqlSession;
	
	@Test
	public void testCRUD(){
//		System.out.println(departmentMapper);
//		departmentMapper.insertSelective(new Department(null, "人事部"));
//		departmentMapper.insertSelective(new Department(null, "管理部"));
	
		EmployeeMapper mapper =  sqlSession.getMapper(EmployeeMapper.class);
		for(int i = 0; i < 100; i ++){
			mapper.insertSelective(new Employee(null, "M", 1));
		}
	}
}
