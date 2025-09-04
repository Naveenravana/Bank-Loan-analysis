use data_analysis;

select count(*) As Totalrows from finance_2;
select count(*) As Totalrows from finance_0;


DELIMITER $$

CREATE PROCEDURE GetFinanceFullJoin()
BEGIN
    SELECT finance_0.*, finance_2.*
    FROM finance_0
    LEFT JOIN finance_2
        ON finance_0.id = finance_2.id

    UNION

    SELECT finance_0.*, finance_2.*
    FROM finance_0
    RIGHT JOIN finance_2
        ON finance_0.id = finance_2.id;
END$$

DELIMITER ;

CALL GetFinanceFullJoin();

DELIMITER $$

CREATE PROCEDURE GetLoanAmountByYear()
BEGIN
    SELECT 
        Year AS loan_year, SUM(loan_amnt) AS total_loan_amnt
    FROM finance_0
    GROUP BY Year
    ORDER BY Year;
END $$

DELIMITER ;

CALL GetLoanAmountByYear();
DELIMITER $$
create procedure GradeSubGrade_Revol()
begin
 SELECT grade, sub_grade, SUM(revol_bal) AS total_Revol
FROM (
    SELECT f0.grade, f0.sub_grade, f2.revol_bal FROM finance_0 f0 LEFT JOIN finance_2 f2 ON f0.id = f2.id
    
    UNION ALL
    
    SELECT f0.grade, f0.sub_grade, f2.revol_bal FROM finance_0 f0 RIGHT JOIN finance_2 f2 ON f0.id = f2.id
) AS combined
GROUP BY grade, sub_grade
ORDER BY grade, sub_grade;
end $$
DELIMITER ;

call GradeSubGrade_Revol();



DELIMITER $$

CREATE PROCEDURE GetTotalPaymentByVerificationStatus()
BEGIN
    SELECT  verification_status, SUM(total_pymnt) AS Total_Paymnt
    FROM (
       SELECT f0.verification_status, f2.total_pymnt FROM finance_0 f0 LEFT JOIN finance_2 f2 ON f0.id = f2.id
       
        UNION ALL
        
        SELECT f0.verification_status, f2.total_pymnt FROM finance_0 f0 RIGHT JOIN finance_2 f2 ON f0.id = f2.id ) AS combined
    GROUP BY verification_status
    ORDER BY verification_status;
END $$

DELIMITER ;

call GetTotalPaymentByVerificationStatus();
    
    DELIMITER $$
    
    create procedure StateMonthByLoanStatus()
    begin
    SELECT  Month, addr_state, COUNT(loan_status) AS LoanCount
FROM (
    SELECT f0.Month, f0.addr_state, f0.loan_status FROM finance_0 f0 LEFT JOIN finance_2 f2 ON f0.id = f2.id

    UNION ALL


    SELECT f0.Month, f0.addr_state, f0.loan_status FROM finance_0 f0 RIGHT JOIN finance_2 f2 ON f0.id = f2.id) AS combined
GROUP BY Month, addr_state
ORDER BY Month, addr_state;

    end $$
    
    DELIMITER ;
call  StateMonthByLoanStatus();

 DELIMITER $$
create procedure HomeOwnerShip_LastPaymtDate()
begin
select Year, home_ownership, sum(last_pymnt_amnt) LastPaid from ( 
select f0.home_ownership , f2.last_pymnt_amnt  from finance_0 f0 LEFT JOIN finance_2 f2 ON f0.id = f2.id

union all

select f0.home_ownership, f2.last_pymnt_amnt from finance_0 f0 RIGHT JOIN finance_2 f2 ON f0.id = f2.id) AS combined
group by home_ownership
order by home_ownership;

 end $$
    
    DELIMITER ;
    
call HomeOwnerShip_LastPaymtDate();

 DELIMITER $$
 
 create procedure GradeByAnnualincome()
 begin
select grade, sum(annual_inc) as income from (
select f0.grade, f0.annual_inc from finance_0 f0 LEFT JOIN finance_2 f2 ON f0.id = f2.id

union all
select f0.grade, f0.annual_inc  from finance_0 f0 RIGHT JOIN finance_2 f2 ON f0.id = f2.id) AS combined

group by grade
order by grade;

 end $$
    
    DELIMITER ;
    
call  GradeByAnnualincome();

DELIMITER $$

create procedure TotalLoanAmnt()

begin

select round (sum(loan_amnt)) as "Total_loan_amnt" from finance_0;

end $$
DELIMITER ;


call TotalLoanAmnt();

DELIMITER $$

create procedure Avgintrate()
begin

select round (Avg(int_rate), 4) as "Avgintrate" from finance_0;

end $$
DELIMITER ;

call Avgintrate();
DELIMITER $$

create procedure Purposebyintrate()
begin

select purpose, avg(int_rate) as Int_rate from ( select f0.purpose, f0.int_rate from finance_0 f0 LEFT JOIN finance_2 f2 ON f0.id = f2.id

union all 
select f0.purpose, f0.int_rate from finance_0 f0 RIGHT JOIN finance_2 f2 ON f0.id = f2.id)AS combined

group by purpose
order by purpose;

 end $$
 
DELIMITER $$
   
call Purposebyintrate();


DROP PROCEDURE IF EXISTS HomeOwnerShip_LastPaymtDate;

DELIMITER $$
CREATE PROCEDURE HomeOwnerShip_LastPaymtDate() 
BEGIN
 SELECT combined.Year, combined.home_ownership, SUM(combined.last_pymnt_amnt) AS LastPaid
 FROM (SELECT f0.Year, f0.home_ownership, f2.last_pymnt_amnt FROM finance_0 f0 LEFT JOIN finance_2 f2 ON f0.id = f2.id 
 UNION 
 SELECT NULL AS Year, f0.home_ownership, f2.last_pymnt_amnt FROM finance_0 f0 RIGHT JOIN finance_2 f2 ON f0.id = f2.id WHERE f0.id IS NULL) AS combined 
 GROUP BY combined.Year, combined.home_ownership 
 ORDER BY combined.home_ownership; 
 END$$
DELIMITER ;

call HomeOwnerShip_LastPaymtDate();


DELIMITER $$
 create procedure MaxAnnualIncome()
 begin
 select round (Max(Annual_inc), 1) as "Max_income" from finance_0;
 end $$
 DELIMITER ;

call MaxAnnualIncome();

DELIMITER $$

create procedure DTITotal_pymnt()

begin 
select avg(dti) as DTI, sum(total_pymnt) as TotalPayment, combined.year from (select f0.dti, f0.Year, f2.total_pymnt FROM finance_0 f0 LEFT JOIN finance_2 f2 ON f0.id = f2.id 
union all
select NULL AS Year, f0.dti, f2.total_pymnt from finance_0 f0 RIGHT JOIN finance_2 f2 ON f0.id = f2.id WHERE f0.id IS NULL) AS combined

group by combined.Year 
order by combined.Year;

end$$

DELIMITER ;

call  DTITotal_pymnt();
