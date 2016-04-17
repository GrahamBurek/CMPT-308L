
-- Lab 10 (Stored Procedure). Author: Graham Burek

-- Write two functions (stored procedures) that take an integer course number as their only  
-- parameter:


-- function PreReqsFor(courseNum) - Returns the immediate prerequisites for the 
-- passed-in course number:
create or replace function PreReqsFor(integer) returns setof integer as 
$$ 
declare
   cnumber alias for $1;
begin
      return query select p.prereqnum
      from   Prerequisites p
      where  p.coursenum = cnumber;
end;
$$ 
language plpgsql;

-- function IsPreReqFor(courseNum) - Returns the courses for which the passed-in course  
-- number is an immediate pre-requisite:

create or replace function IsPreReqFor(integer) returns setof integer as
$$
declare
    cnumber alias for $1;
begin
      return query select p.coursenum
                   from   Prerequisites p
                   where  p.prereqnum = cnumber;
end;
$$
language plpgsql;
