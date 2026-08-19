/*
================================================================================
 RECRUITMENT INTERVIEW / FEEDBACK TABLES AND STORED PROCEDURES
 Source: Database/Recruitment_Functional_Separation_All_Tables_Procedures.sql
 Generated: 2026-08-18

 Contents are extracted as complete object blocks from the functional separation script.
 Review dependencies and CREATE vs ALTER strategy before running in production.
 Tables extracted: 6
 Table ALTER/DEFAULT blocks extracted: 1
 Stored procedure blocks extracted: 29
================================================================================
*/
USE [Recruitment]
GO

/* ========================== TABLES ========================== */
/****** Object:  Table [dbo].[Tbl_Interview_Taken_Details]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tbl_Interview_Taken_Details](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Cand_Regno] [varchar](max) NULL,
	[candidateid] [bigint] NULL,
	[InterviewTaken_DeptID] [bigint] NULL,
	[InterviewTaken_PersonID] [bigint] NULL,
	[Interview_Remarks] [varchar](max) NULL,
	[InterviewRound] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[tbl_RecruiterInterviewersSchedule]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_RecruiterInterviewersSchedule](
	[ScheduleID] [int] IDENTITY(1,1) NOT NULL,
	[CandidateRegistrationNumber] [nvarchar](max) NULL,
	[InterviewersRoundNo] [int] NULL,
	[InterviewersID] [bigint] NULL,
	[InterviewersDeptID] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[UpdateOn] [datetime] NULL,
	[CreatedBY] [int] NULL,
	[UpdateBy] [int] NULL,
	[ScheduleBY] [bigint] NULL,
	[ScheduleDate] [date] NULL,
	[ScheduleTime] [nvarchar](max) NULL,
	[InterviewRemarks] [nvarchar](max) NULL,
	[InterviewStatus] [int] NULL,
	[ShortlistedBY] [bigint] NULL,
	[InterviewFeedbackFilePath] [nvarchar](max) NULL,
	[InterviewFeedbackFileExtension] [nvarchar](max) NULL,
 CONSTRAINT [PK_tbl_RecruiterInterviewersSchedule] PRIMARY KEY CLUSTERED 
(
	[ScheduleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[tbl_Tracker_InterviewTaken_Details]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Tracker_InterviewTaken_Details](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Plmapid] [int] NULL,
	[CandidatesName] [nvarchar](max) NULL,
	[InterviewTakenId] [nvarchar](max) NULL,
	[CandidatesPsychometryReport] [nvarchar](max) NULL,
	[CandidateBackgroundVerificationReport] [nvarchar](max) NULL,
	[ChallengesName] [nvarchar](max) NULL,
	[Remarks] [nvarchar](max) NULL,
	[CandidateStatus] [nvarchar](max) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedDate] [datetime] NULL,
	[InterviewYearMonth] [nvarchar](max) NULL,
	[InterviewWeekNumber] [nvarchar](max) NULL,
 CONSTRAINT [PK_tbl_Tracker_InterviewTaken_Details] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruitinterviewdetails]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruitinterviewdetails](
	[interviewid] [bigint] IDENTITY(1,1) NOT NULL,
	[postid] [int] NULL,
	[postname] [varchar](300) NULL,
	[locid] [int] NULL,
	[candidateid] [int] NULL,
	[candidatename] [varchar](300) NULL,
	[interviewstatus] [int] NULL,
	[isactive] [int] NULL,
	[createdby] [varchar](50) NULL,
	[modifiedby] [varchar](50) NULL,
	[createddate] [datetime] NULL,
	[modifieddate] [datetime] NULL,
 CONSTRAINT [PK_trecruitmaininterviewdetails] PRIMARY KEY CLUSTERED 
(
	[interviewid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruitinterviewrounddetails]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruitinterviewrounddetails](
	[id] [bigint] NOT NULL,
	[interviewid] [int] NULL,
	[postid] [int] NULL,
	[postname] [varchar](200) NULL,
	[locid] [int] NULL,
	[candidateid] [int] NULL,
	[candidatename] [varchar](200) NULL,
	[finterviewerid] [varchar](50) NULL,
	[sinterviewerid] [varchar](50) NULL,
	[interviewtime] [varchar](50) NULL,
	[interviewdate] [date] NULL,
	[interviewmode] [int] NULL,
	[interviewroundnumber] [int] NULL,
	[interviewround] [int] NULL,
	[interviewfeedback] [varchar](1000) NULL,
	[interviewcomments] [varchar](1000) NULL,
	[roundstatus] [int] NULL,
	[intlocation] [varchar](max) NULL,
	[intcity] [int] NULL,
	[intstate] [int] NULL,
	[intcountry] [int] NULL,
	[isactive] [varchar](10) NULL,
	[createdby] [varchar](100) NULL,
	[modifiedby] [varchar](100) NULL,
	[createddate] [datetime] NULL,
	[modifieddate] [datetime] NULL,
 CONSTRAINT [PK_trecruitinterviewrounddetails] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruitinterviewroundssummary]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruitinterviewroundssummary](
	[idintsummary] [bigint] NOT NULL,
	[postid] [int] NULL,
	[postname] [varchar](300) NULL,
	[locid] [int] NULL,
	[candidateid] [int] NULL,
	[candidatename] [varchar](200) NULL,
	[candidatestatus] [int] NULL,
	[interviewstatus] [int] NULL,
	[interviewid] [int] NULL,
	[interviewroundid] [bigint] IDENTITY(1,1) NOT NULL,
	[finterviewerid] [varchar](20) NULL,
	[sinterviewerid] [varchar](20) NULL,
	[interviewername] [varchar](100) NULL,
	[interviewtime] [time](7) NULL,
	[interviewdate] [date] NULL,
	[interviewmode] [int] NULL,
	[interviewroundnumber] [int] NULL,
	[interviewroundname] [int] NULL,
	[location] [varchar](1000) NULL,
	[interviewcityid] [int] NULL,
	[interviewstateid] [int] NULL,
	[interviewcityname] [varchar](50) NULL,
	[interviewstatename] [varchar](50) NULL,
	[interviewcountryid] [int] NULL,
	[interviewcountryname] [varchar](50) NULL,
	[createdby] [varchar](50) NULL,
	[createdbyname] [varchar](50) NULL,
	[interviewfeedback] [varchar](1000) NULL,
	[interviewcomments] [varchar](1000) NULL,
	[round_status] [int] NULL,
	[modifiedby] [varchar](50) NULL,
	[createddate] [datetime] NULL,
	[modifieddate] [datetime] NULL,
	[isactive] [varchar](10) NULL,
 CONSTRAINT [PK_trecruitinterviewroundssummary] PRIMARY KEY CLUSTERED 
(
	[idintsummary] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO




/* ----------------------------------------------------------------------------
   8. INTERVIEW - schedule, rounds, feedback, interviewer assignment and interview outcome
   STORED PROCEDURES
---------------------------------------------------------------------------- */

/* ---- PRIMARY / NON-TEMP PROCEDURES ---- */

/* ========================== TABLE ALTER / DEFAULTS ========================== */
ALTER TABLE [dbo].[tbl_Tracker_InterviewTaken_Details] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO

/* ========================== STORED PROCEDURES ========================== */
/* Functional group: 08_INTERVIEW; referenced grouped tables: tbl_RecruiterInterviewersSchedule, trecruitcanbasicdtls, trecruitcandidateresgisterdtls, trecruitcandidatesignup, trecruitpostlocationmap */
/****** Object:  StoredProcedure [dbo].[porc_RecruiterInterviewAssigned]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[porc_RecruiterInterviewAssigned]             
@CandiRegNumber nvarchar(200)=NULL,    
@CandInterRoundNo nvarchar(200)=NULL,    
@InterviewersEmpID nvarchar(MAX)=NULL,    
@CreatedBY nvarchar(200)=NULL,    
@UpdateOn nvarchar(200)=NULL,    
@Action nvarchar(100)     
AS             
BEGIN        
   IF @Action='INSERT'    
   BEGIN    
    BEGIN TRY                                  
    BEGIN TRANSACTION;  
	  Declare @MDEmpNo varchar(100)='101343'

      IF @InterviewersEmpID IS NOT NULL AND @InterviewersEmpID <> ''    
      BEGIN    
       --   DELETE  tbl_RecruiterInterviewersSchedule    
       --Where CandidateRegistrationNumber=@CandiRegNumber and InterviewersRoundNo=@CandInterRoundNo    
       IF(@CandInterRoundNo ='4')    
       BEGIN 
		   DECLARE @postDeptMDempEmail nvarchar(max)
		   DECLARE @postDeptHODempno nvarchar(max)    
		   DECLARE @postDeptHODempEmail nvarchar(max)   
		   DECLARE @createByPost nvarchar(max)    
		   DECLARE @createByPostDpetId nvarchar(max)    
      
	        --Fiend MD Sir amil id
			 Select @postDeptMDempEmail=empemail from  essp.dbo.Empbasic where empno =@MDEmpNo
	       
		   --Fiend Post create by dept hod   
		   Select @createByPost=createdby from trecruitpostlocationmap where postid =    
			(select B.IDPost from trecruitcandidatesignup A          
			 INNER JOIN trecruitcandidateresgisterdtls B ON A.username=B.username          
			 INNER JOIN trecruitcanbasicdtls C ON A.CandidateID=C.candidateid          
			 WHERE C.registrationnumber=Ltrim(Rtrim(@CandiRegNumber)))    
		   select @createByPostDpetId=empdept from essp.dbo.Empbasic where empemail=@createByPost    
             
			 --Fiend Dpartment Hod by department Id  
		   Select @InterviewersEmpID= B.empno from essp.dbo.Employee_DepartmentHODMap A    
		   INNER JOIN essp.dbo.Empbasic B ON B.empno=A.empno    
		   Where DepartmentID=@createByPostDpetId    
		   --Insert Md sir id
		INSERT tbl_RecruiterInterviewersSchedule     
		(CandidateRegistrationNumber,InterviewersRoundNo,InterviewersID,InterviewersDeptID,CreatedOn,CreatedBY)    
		SELECT  @CandiRegNumber,@CandInterRoundNo,A.Name as Empno,B.empdept,GETDATE(),@CreatedBY FROM dbo.splitstring(@MDEmpNo) A     
		Inner join essp.dbo.Empbasic B on B.empno=A.Name    

       END    
       INSERT tbl_RecruiterInterviewersSchedule     
       (CandidateRegistrationNumber,InterviewersRoundNo,InterviewersID,InterviewersDeptID,CreatedOn,CreatedBY)    
       SELECT  @CandiRegNumber,@CandInterRoundNo,A.Name as Empno,B.empdept,GETDATE(),@CreatedBY FROM dbo.splitstring(@InterviewersEmpID) A     
       Inner join essp.dbo.Empbasic B on B.empno=A.Name    
           
       --Mail SEND START    
       DECLARE @tableHTML NVARCHAR(MAX);        
       DECLARE @subjectMail NVARCHAR(MAX);       
       DECLARE @candidatePostName NVARCHAR(MAX);     
       DECLARE @candidateName NVARCHAR(MAX);    
       --DECLARE @DDDD NVARCHAR(MAX)='3166,3033';  
  
       DECLARE @SelectInterviewersEmail  nvarchar(max)    
       Select @SelectInterviewersEmail=STRING_AGG(A.empemail, ';') from essp.dbo.Empbasic A where empno IN (Select Name FROM dbo.splitstring(@InterviewersEmpID))    
    
         --Gate Candidate Post name    
       select @candidatePostName=B.Appliedpost from trecruitcandidatesignup A    
       INNER JOIN trecruitcandidateresgisterdtls B ON A.username=B.username    
       INNER JOIN trecruitcanbasicdtls C ON A.CandidateID=C.candidateid    
       WHERE C.registrationnumber=ltrim(rtrim(@CandiRegNumber))      
    
           
       --Gate Candidate Name    
       Select @candidateName=dbo.Employee_FullName(A.firstname,A.middlename,A.lastname)  from trecruitcanbasicdtls A    
       Where registrationnumber=@CandiRegNumber    
    
    
    
       --Find Interview Round      
       if @CandInterRoundNo ='1'    
       BEGIN    
        set @subjectMail='First Round Interview Schedule & Candidate Profiles'    
       END    
       ELSE IF  @CandInterRoundNo ='2'    
       BEGIN    
       set @subjectMail='Second Round Interview Schedule & Candidate Profiles'    
       END    
       ELSE IF  @CandInterRoundNo ='3'    
       BEGIN    
         set @subjectMail='3rd Round Interview Schedule & Candidate Profiles'    
       END    
  ELSE IF  @CandInterRoundNo ='4'    
       BEGIN    
         set @subjectMail='Final Round Interview Schedule & Candidate Profiles' 
		  set @SelectInterviewersEmail=@SelectInterviewersEmail+';'+@postDeptMDempEmail
		 --@postDeptMDempEmail
       END   
  
       SET @tableHTML='<html>      
        <body style="font-family:Tahoma;font-size:14px;">      
         <p>Dear Sir/Madam,</p>      
         <p>Please find below the details for the first-round interviews</p>      
         <br/>    
         <b>Interview Details:</b>    
         <br/>     
         <ul>    
           <li><p><b>Candidate Name:</b> '+@candidateName+'</p></li>    
           <li><p><b>Post: </b> '+@candidatePostName+'</p></li>    
         </ul>    
         <br/>       
         <p>Additionally, I have attached the candidate profiles for your reference. Please mention date and time when you take interview in recruitment portal</p>    
         <br/>    
         <p>Let me know if you need any further information.</p>    
         <br/>    
         <p>Thank You.</p>    
         </body>      
       </html>'    
       EXEC msdb.dbo.sp_send_dbmail                                                          
       @profile_name = 'Mendine_Recruitment_Profile'                                             
         ,@recipients = @SelectInterviewersEmail                                                  
         ,@subject = @subjectMail                                                  
         ,@body =                  
          @tableHTML                                                  
         ,@importance ='HIGH'                
         ,@body_format = 'HTML'     
         --Mail send end    
    
      END    
      COMMIT TRANSACTION;                                         
     END TRY                                  
     BEGIN CATCH                                  
      ROLLBACK TRANSACTION;                                  
     END CATCH;    
  END    
   ELSE IF  @Action='SELECT'    
   BEGIN    
     SELECT A.ScheduleID,dbo.Employee_FullName(B.empfirstname,B.empmiddlename,B.emplastname)InterviewerName,C.Department     
   ,CONVERT(VARCHAR,A.ScheduleDate,105)As ScheduleDate    
   ,A.ScheduleTime    
   ,A.InterviewRemarks    
   ,CASE     
    WHEN A.InterviewStatus = 1 THEN 'SELECTED'    
    WHEN A.InterviewStatus = 2 THEN 'REJECTED'    
    WHEN A.InterviewStatus = 3 THEN 'HOLD'    
    ELSE NULL -- For any other unexpected values    
   END AS InterviewStatus    
   ,(Select dbo.Employee_FullName(empBasic.empfirstname,empBasic.empmiddlename,empBasic.emplastname) EmployeeName from essp.dbo.Empbasic empBasic Where empBasic.empno=A.ShortlistedBY)As ShortlistedBY    
   ,A.InterviewFeedbackFilePath    
      ,A.InterviewFeedbackFileExtension    
    FROM  tbl_RecruiterInterviewersSchedule A    
    INNER JOIN essp.dbo.Empbasic B ON B.empno =A.InterviewersID    
    INNER JOIN essp.dbo.department C ON C.DepartmentId=A.InterviewersDeptID    
    Where A.CandidateRegistrationNumber=@CandiRegNumber and A.InterviewersRoundNo=@CandInterRoundNo    
     

   END    
END
GO

/* Functional group: 08_INTERVIEW; referenced grouped tables: tbl_RecruiterHR_Details, tbl_RecruiterInterviewersSchedule, trecruitcanbasicdtls, trecruitcandidateresgisterdtls, trecruitcandidatesignup, trecruitpostlocationmap */
/****** Object:  StoredProcedure [dbo].[porc_SetInterviewSchedule]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[porc_SetInterviewSchedule]          
--SetInterviewSchedule        
@empno varchar(100),        
@Action nvarchar(100),        
@scheduleDate nvarchar(max)=null,        
@scheduleTime nvarchar(max)=null,        
@CandidateRegistrationNumber nvarchar(max)=null,        
@InterviewersRoundNo nvarchar(max)=null,        
@ScheduleID nvarchar(max)=null,      
@InterviewStatus varchar(10)=null,      
@InterviewRemarks nvarchar(max)=null,      
@InterviewFeedbackFilePath nvarchar(max)=null,      
@InterviewFeedbackFileExtension nvarchar(max)=null,      
@status VARCHAR(MAX) = NULL OUTPUT        
AS                 
BEGIN         
  Declare @MDEmpNo varchar(100)=dbo.GetCompanyMDEmpNo()  
  Declare @postDeptMDempEmail varchar(500)    
   Declare @createByPost varchar(500)    
   Declare @createByPostDpetId varchar(500)    
   Declare @DeptHODEmpEmail varchar(500)    
   --Fiend MD Sir amil id    
 Select @postDeptMDempEmail=empemail from  abcinfotechpvtltdESSP.dbo.Empbasic where empno =@MDEmpNo    
 --Fiend Post create by dept hod       
     Select @createByPost=createdby from trecruitpostlocationmap where postid =        
   (select B.IDPost from trecruitcandidatesignup A              
    INNER JOIN trecruitcandidateresgisterdtls B ON A.username=B.username              
    INNER JOIN trecruitcanbasicdtls C ON A.CandidateID=C.candidateid              
    WHERE C.registrationnumber=Ltrim(Rtrim(@CandidateRegistrationNumber)))        
     select @createByPostDpetId=empdept from abcinfotechpvtltdESSP.dbo.Empbasic where empemail=@createByPost        
    
  --Fiend Dpartment Hod by department Id      
     Select @DeptHODEmpEmail= B.emppersonalemail from abcinfotechpvtltdESSP.dbo.Employee_DepartmentHODMap A        
     INNER JOIN abcinfotechpvtltdESSP.dbo.Empbasic B ON B.empno=A.empno        
     Where DepartmentID=@createByPostDpetId    
    
    
  IF @Action='SELECT'        
   BEGIN        
        Select  A.ScheduleID,A.CandidateRegistrationNumber,A.InterviewersRoundNo,dbo.Employee_FullName(B.firstname,B.middlename,B.lastname)as CandidateName        
            ,(Select B.Appliedpost from trecruitcandidatesignup sing      
      INNER JOIN trecruitcandidateresgisterdtls B on sing.username=B.username        
      INNER JOIN trecruitcanbasicdtls C ON C.candidateid = sing.CandidateID        
                 where C.registrationnumber=A.CandidateRegistrationNumber) AS PostName        
       ,A.InterviewersRoundNo        
       , CONVERT(VARCHAR,A.ScheduleDate,105)As ScheduleDate,A.ScheduleTime        
       ,(Select dbo.Employee_FullName(empBasic.empfirstname,empBasic.empmiddlename,empBasic.emplastname) EmployeeName from abcinfotechpvtltdESSP.dbo.Empbasic empBasic Where empBasic.empno=A.ScheduleBY)As ScheduleBY        
       ,A.InterviewRemarks      
    , CASE       
   WHEN A.InterviewStatus = 1 THEN 'SELECTED'      
   WHEN A.InterviewStatus = 2 THEN 'REJECTED'      
   WHEN A.InterviewStatus = 3 THEN 'HOLD'      
   ELSE NULL -- For any other unexpected values      
  END AS InterviewStatus      
  ,(Select dbo.Employee_FullName(empBasic.empfirstname,empBasic.empmiddlename,empBasic.emplastname) EmployeeName from abcinfotechpvtltdESSP.dbo.Empbasic empBasic Where empBasic.empno=A.ShortlistedBY)As ShortlistedBY      
  ,A.InterviewFeedbackFilePath      
  ,A.InterviewFeedbackFileExtension      
    from tbl_RecruiterInterviewersSchedule A        
       INNER JOIN trecruitcanbasicdtls B ON B.registrationnumber=A.CandidateRegistrationNumber        
       where A.InterviewersID=@empno    
    order by CreatedOn desc  
   END        
   ELSE IF (@Action='INSERT')        
   BEGIN        
   Update tbl_RecruiterInterviewersSchedule set          
      ScheduleDate=@scheduleDate,        
   ScheduleTime=@scheduleTime,        
   ScheduleBY=@empno        
   where ScheduleID=@ScheduleID        
        
     --Mail send Recruiter Satart        
   DECLARE @RecruiterHRM nvarchar(max)        
   SELECT @RecruiterHRM = STRING_AGG(A.empemail, ';')           
   from abcinfotechpvtltdESSP.dbo.Empbasic A        
   INNER JOIN tbl_RecruiterHR_Details B ON A.empno=B.Empno        
              
   DECLARE @tableHTML NVARCHAR(MAX);          
   DECLARE @subjectMail NVARCHAR(MAX);           
   DECLARE @candidateName NVARCHAR(MAX);          
   DECLARE @candidatePostName NVARCHAR(MAX);        
   DECLARE @interviewersRoundMass nvarchar(max);        
 DECLARE @interviewersName nvarchar(max);        
        
   --Get Candidate Name        
     Select @candidateName=dbo.Employee_FullName(A.firstname,A.middlename,A.lastname)  from trecruitcanbasicdtls A          
     Where registrationnumber=(Select CandidateRegistrationNumber from tbl_RecruiterInterviewersSchedule where ScheduleID=@ScheduleID)          
        
      --Get Candidate Post name          
     select @candidatePostName=B.Appliedpost from trecruitcandidatesignup A          
     INNER JOIN trecruitcandidateresgisterdtls B ON A.username=B.username          
     INNER JOIN trecruitcanbasicdtls C ON A.CandidateID=C.candidateid          
     WHERE C.registrationnumber=(Select CandidateRegistrationNumber from tbl_RecruiterInterviewersSchedule where ScheduleID=@ScheduleID)        
        
     --Get Interviewers name        
    Select @interviewersName=dbo.Employee_FullName(A.empfirstname,A.empmiddlename,A.emplastname) from  abcinfotechpvtltdESSP.dbo.Empbasic A  where empno=@empno        
            
    --Get Interviewers Round         
     if @InterviewersRoundNo ='1'          
     BEGIN          
    set @interviewersRoundMass='First Round'          
     END          
     ELSE IF  @InterviewersRoundNo ='2'          
     BEGIN          
     set @interviewersRoundMass='Second Round'          
END          
     ELSE IF  @InterviewersRoundNo ='3'          
     BEGIN          
       set @interviewersRoundMass='3rd Round'          
     END         
   ELSE IF  @InterviewersRoundNo ='4'          
     BEGIN          
       set @interviewersRoundMass='Final Round'          
     END         
   set @subjectMail='Interview Scheduled – ' + @candidateName + ' for ' + @candidatePostName;        
   SET @tableHTML='<body style="font-family:Tahoma;font-size:14px;">            
      <p>Dear Sir/Madam,</p>            
      <p>This is an automated notification to inform you that a '+@interviewersRoundMass+' Interview has <br/> been scheduled for the following candidate:</p>         
      <br/>           
      <ul>                   
       <li><p><b>Candidate Name:</b> '+@candidateName+'</p></li>                 
       <li><p><b>Position: </b>'+@candidatePostName+'</p></li>          
       <li><p><b>Interview Date: </b> '+  CONVERT(VARCHAR(8), CAST(@scheduleDate AS DATE), 3)+'</p></li>        
       <li><p><b>Interview Time: </b> '+@scheduleTime+'</p></li>        
       <li><p><b>Interviewer: </b>'+@interviewersName+'</p></li>        
      </ul>          
      <br/>             
      <p>Please review the details and take necessary actions if required.</p>          
      <br/>          
      <p>If you have any questions, feel free to reach out.</p>          
      <br/>          
      <p>Thank You.</p>          
      </body>            
      </html>'        
 EXEC msdb.dbo.sp_send_dbmail                                                              
       @profile_name = 'Mendine_Recruitment_Profile'                                                 
         ,@blind_copy_recipients = @RecruiterHRM                                                      
         ,@subject = @subjectMail                                                      
         ,@body =                      
          @tableHTML                                                      
         ,@importance ='HIGH'                    
         ,@body_format = 'HTML'      
 --Mail send Recruiter Satart        
   END       
   ELSE IF (@Action='SHORTLISTED_STATUS')      
   BEGIN     
       IF EXISTS (  
			   SELECT 1   
			   FROM tbl_RecruiterInterviewersSchedule   
			   WHERE ScheduleID = @ScheduleID   
			   AND InterviewStatus IS NULL  
         ) or @empno=dbo.GetCompanyMDEmpNo()  
    BEGIN    
        Update tbl_RecruiterInterviewersSchedule set       
      InterviewStatus=@InterviewStatus,      
      ShortlistedBY=@empno      
      WHERE CandidateRegistrationNumber=@CandidateRegistrationNumber    
         AND InterviewersRoundNo=@InterviewersRoundNo      
        Update tbl_RecruiterInterviewersSchedule set          
          InterviewRemarks=@InterviewRemarks,      
    InterviewFeedbackFilePath=@InterviewFeedbackFilePath,      
    InterviewFeedbackFileExtension=@InterviewFeedbackFileExtension      
          where ScheduleID=@ScheduleID      
    -- MAIL SEND  START    
    DECLARE @takeAllInterviewers NVARCHAR(MAX) = '';    
    SELECT @takeAllInterviewers =     
    ISNULL(@takeAllInterviewers, '') + '<li><strong>' +     
    dbo.Employee_FullName(B.empfirstname, B.empmiddlename, B.emplastname) +     
    '</strong></li>'    
    FROM tbl_RecruiterInterviewersSchedule A    
    INNER JOIN abcinfotechpvtltdESSP.dbo.Empbasic B ON A.InterviewersID = B.empno    
    WHERE A.CandidateRegistrationNumber =@CandidateRegistrationNumber    
    AND A.InterviewersRoundNo = @InterviewersRoundNo;    
    
     --Recruiter Mail id    
     SELECT @RecruiterHRM = STRING_AGG(A.empemail, ';')           
     from abcinfotechpvtltdESSP.dbo.Empbasic A        
    INNER JOIN tbl_RecruiterHR_Details B ON A.empno=B.Empno    
      
     --Get Candidate Post name          
     select @candidatePostName=B.Appliedpost from trecruitcandidatesignup A          
     INNER JOIN trecruitcandidateresgisterdtls B ON A.username=B.username          
     INNER JOIN trecruitcanbasicdtls C ON A.CandidateID=C.candidateid          
     WHERE C.registrationnumber=(Select CandidateRegistrationNumber from tbl_RecruiterInterviewersSchedule where ScheduleID=@ScheduleID)        
        
    --Get Candidate Name    
    Select @candidateName=dbo.Employee_FullName(A.firstname,A.middlename,A.lastname)  from trecruitcanbasicdtls A          
     Where registrationnumber=(Select CandidateRegistrationNumber from tbl_RecruiterInterviewersSchedule where ScheduleID=@ScheduleID)      
    --Get Interviewers Round         
       if @InterviewersRoundNo ='1'          
       BEGIN          
          set @interviewersRoundMass='First Round'       
          Set @RecruiterHRM=@RecruiterHRM+';'+ @postDeptMDempEmail+';'+ @DeptHODEmpEmail    
       END          
       ELSE IF  @InterviewersRoundNo ='2'          
       BEGIN          
      set @interviewersRoundMass='Second Round'      
      Set @RecruiterHRM=@RecruiterHRM+';'+ @postDeptMDempEmail+';'+ @DeptHODEmpEmail    
       END          
       ELSE IF  @InterviewersRoundNo ='3'          
       BEGIN          
         set @interviewersRoundMass='Third Round'     
       Set @RecruiterHRM=@RecruiterHRM+';'+ @postDeptMDempEmail+';'+ @DeptHODEmpEmail    
       END         
     ELSE IF  @InterviewersRoundNo ='4'          
       BEGIN          
         set @interviewersRoundMass='Final Round'          
       --If final interview     
       END       
  
    set @subjectMail='Shortlisting Update ' + @candidatePostName;    
    --Take Interviewrs     
     --Get Selected Interviewers name        
      Select @interviewersName=dbo.Employee_FullName(A.empfirstname,A.empmiddlename,A.emplastname) from  abcinfotechpvtltdESSP.dbo.Empbasic A  where empno=@empno      
          -- Mail body start  
          if @InterviewStatus= '1'  
    BEGIN  
     SET @tableHTML='<body style="font-family:Tahoma;font-size:14px;">    
       <p>Dear Sir/Madam,</p>    
       <p>I hope you are doing well.</p>    
       <p>We are pleased to inform you that <strong>'+@candidateName+'</strong> has been shortlisted for the next round of the <strong>'+@candidatePostName+'</strong> position, after successfully completing the <strong>'+@interviewersRoundMass+'</strong>
 round of interview.</p>    
       <p>The interview panel consisted of:</p>    
     <br/>     
       <ul>    
     '+@takeAllInterviewers+'    
       </ul>    
     <br/>     
       <p>Among them, <strong>'+@interviewersName+'</strong> has been finalized for further interview processes.</p>    
       <p>Kindly proceed with the necessary formalities for the next steps in the hiring process.</p>     
        <br/>          
     <p>Thank You.</p>    
      </body>'   
    END  
    ELSE IF @InterviewStatus= '2'  
    BEGIN  
     SET @tableHTML='<body style="font-family:Tahoma;font-size:14px;">    
       <p>Dear Sir/Madam,</p>    
       <p>I hope you are doing well.</p>    
       <p>We are pleased to inform you that <strong>'+@candidateName+'  has not been shortlisted for the next round </strong> of the <strong>'+@candidatePostName+'</strong> position, following the completion of the <strong>'+@interviewersRoundMass+'</stro
ng> round of interview.</p>    
       <p>The interview panel consisted of:</p>    
     <br/>     
       <ul>    
     '+@takeAllInterviewers+'    
       </ul>    
     <br/>     
       <p>Among them, <strong>'+@interviewersName+'</strong>has marked the interview status as Rejected based on the candidates evaluation.</p>  
      <p>Kindly proceed with the necessary formalities for the next process.</p>    
      <br/>          
      <p>Thank You.</p>    
      </body>'   
    END  
    ELSE IF @InterviewStatus= '3'  
    BEGIN  
     SET @tableHTML='<body style="font-family:Tahoma;font-size:14px;">    
       <p>Dear Sir/Madam,</p>    
       <p>I hope you are doing well.</p>    
       <p>We would like to inform you that <strong>'+@candidateName+' has been placed on hold </strong> for the <strong>'+@candidatePostName+'</strong> position, following the completion of the <strong>'+@interviewersRoundMass+'</strong> round of intervie
w.</p>    
       <p>The interview panel consisted of:</p>    
     <br/>     
       <ul>    
     '+@takeAllInterviewers+'    
       </ul>    
     <br/>     
       <p>Among them, <strong>'+@interviewersName+'</strong> has been  has updated the interview status as <strong> On Hold </strong> based on the candidates evaluation.</p>    
      <p>Kindly proceed with the necessary formalities for the next process.</p>    
      <br/>          
      <p>Thank You.</p>    
      </body>'   
    END  
   -- Mail body end    
   EXEC msdb.dbo.sp_send_dbmail                                                              
         @profile_name = 'Mendine_Recruitment_Profile'                                                 
           ,@blind_copy_recipients = @RecruiterHRM                                                      
           ,@subject = @subjectMail                                                      
           ,@body =                      
            @tableHTML                                                      
           ,@importance ='HIGH'                    
           ,@body_format = 'HTML'      
      --  MAIL SEND  END    
     
 END  
 ELSE  
 BEGIN  
     SET @status ='This interview status has already been updated by another interviewer.'  
   RETURN  
 END  
   END       
   ELSE IF (@Action='ADD_ONLY_REMARKS')      
   BEGIN      
    Update tbl_RecruiterInterviewersSchedule set          
   InterviewRemarks=@InterviewRemarks,      
   --InterviewStatus=@InterviewStatus,      
   InterviewFeedbackFilePath=@InterviewFeedbackFilePath,      
   InterviewFeedbackFileExtension=@InterviewFeedbackFileExtension      
     where ScheduleID=@ScheduleID        
   END        
END     
GO

/* Functional group: 08_INTERVIEW; referenced grouped tables: trecruittraker, trecruittrakeruploadfilefinal, trecruittrakeruploadfileone, trecruittrakeruploadfilethree, trecruittrakeruploadfiletwo */
/****** Object:  StoredProcedure [dbo].[PRC_Get_InterviewDetails_AllRounds]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[PRC_Get_InterviewDetails_AllRounds]  
(  
    @Referenceno NVARCHAR(50) = NULL,  
    @CandidateID BIGINT = NULL,  
    @IncludeFiles BIT = 0  
)  
AS  
BEGIN  
    SET NOCOUNT ON;  

    /* =========================================================  
       1. Combine key candidate & reference identifiers across tables
    ========================================================= */  
    WITH KeyMaster AS (
        SELECT 
            COALESCE(t.candidateid, r1.candidateid, r2.candidateid, r3.candidateid, rf.candidateid) AS candidateid,
            COALESCE(t.Referenceno, v.registrationnumber) AS Referenceno
        FROM trecruittraker t
        FULL OUTER JOIN vw_recruittracker v 
            ON v.registrationnumber = t.Referenceno
        FULL OUTER JOIN trecruittrakeruploadfileone r1 
            ON r1.candidateid = COALESCE(t.candidateid, v.candidateid)
        FULL OUTER JOIN trecruittrakeruploadfiletwo r2 
            ON r2.candidateid = COALESCE(t.candidateid, v.candidateid, r1.candidateid)
        FULL OUTER JOIN trecruittrakeruploadfilethree r3 
            ON r3.candidateid = COALESCE(t.candidateid, v.candidateid, r1.candidateid, r2.candidateid)
        FULL OUTER JOIN trecruittrakeruploadfilefinal rf 
            ON rf.candidateid = COALESCE(t.candidateid, v.candidateid, r1.candidateid, r2.candidateid, r3.candidateid)
        WHERE 
            COALESCE(t.candidateid, r1.candidateid, r2.candidateid, r3.candidateid, rf.candidateid) IS NOT NULL
            OR COALESCE(t.Referenceno, v.registrationnumber) IS NOT NULL
    )
    SELECT DISTINCT
        ISNULL(k.Referenceno, '') AS Referenceno,  
        ISNULL(k.candidateid, 0) AS candidateid,  
        ISNULL(t.candidatename, '') AS candidatename,  
        ISNULL(t.postid, 0) AS postid,  
        ISNULL(t.Postname, '') AS Postname,  
        ISNULL(t.locid, 0) AS locid,  
        ISNULL(t.Departmentdivision, '') AS Departmentdivision,  
        ISNULL(t.source, '') AS source,  

        ISNULL(v.registrationnumber, '') AS registrationnumber,  
        ISNULL(v.CandidateName, '') AS ViewCandidateName,  
        ISNULL(v.deptdivision, '') AS deptdivision,  
        ISNULL(v.referredus, '') AS referredus,  
        ISNULL(v.postname, '') AS ViewPostName,  

        /* =========================================================  
           ROUND 1  
        ========================================================= */  

        ISNULL(CONVERT(NVARCHAR(30), t.roneinterviewdate, 120), '') AS R1InterviewDate,  
        ISNULL(CONVERT(NVARCHAR(30), t.roneinterviewenddate, 120), '') AS R1InterviewEndDate,  
        ISNULL(t.roneinterviewernameone, '') AS R1Interviewer1,  
        ISNULL(t.roneinterviewernametwo, '') AS R1Interviewer2,  
        ISNULL(t.roneselect, '') AS R1Selected,  

        ISNULL(r1.fName, '') AS R1Interviewer1FileName,  
        ISNULL(r1.fContentType, '') AS R1Interviewer1ContentType,  
        ISNULL(r1.fRemarksText, '') AS R1Interviewer1Remarks,  
        CASE WHEN r1.fresumefile IS NULL THEN 0 ELSE 1 END AS R1Interviewer1HasFile,  
        ISNULL(DATALENGTH(r1.fresumefile), 0) AS R1Interviewer1FileSize,  

        ISNULL(r1.sName, '') AS R1Interviewer2FileName,  
        ISNULL(r1.sContentType, '') AS R1Interviewer2ContentType,  
        ISNULL(r1.sRemarksText, '') AS R1Interviewer2Remarks,  
        CASE WHEN r1.sresumefile IS NULL THEN 0 ELSE 1 END AS R1Interviewer2HasFile,  
        ISNULL(DATALENGTH(r1.sresumefile), 0) AS R1Interviewer2FileSize,  

        CASE WHEN @IncludeFiles = 1 THEN r1.fresumefile END AS R1Interviewer1File,  
        CASE WHEN @IncludeFiles = 1 THEN r1.sresumefile END AS R1Interviewer2File,  

        /* =========================================================  
           ROUND 2  
        ========================================================= */  

        ISNULL(CONVERT(NVARCHAR(30), t.rtwointerviewdate, 120), '') AS R2InterviewDate,  
        ISNULL(CONVERT(NVARCHAR(30), t.rtwointerviewenddate, 120), '') AS R2InterviewEndDate,  
        ISNULL(t.rtwointerviewernameone, '') AS R2Interviewer1,  
        ISNULL(t.rtwointerviewernametwo, '') AS R2Interviewer2,  
        ISNULL(t.rtwoselect, '') AS R2Selected,  

        ISNULL(r2.fName, '') AS R2Interviewer1FileName,  
        ISNULL(r2.fContentType, '') AS R2Interviewer1ContentType,  
        ISNULL(r2.fRemarksText, '') AS R2Interviewer1Remarks,  
        CASE WHEN r2.fresumefile IS NULL THEN 0 ELSE 1 END AS R2Interviewer1HasFile,  
        ISNULL(DATALENGTH(r2.fresumefile), 0) AS R2Interviewer1FileSize,  

        ISNULL(r2.sName, '') AS R2Interviewer2FileName,  
        ISNULL(r2.sContentType, '') AS R2Interviewer2ContentType,  
        ISNULL(r2.sRemarksText, '') AS R2Interviewer2Remarks,  
        CASE WHEN r2.sresumefile IS NULL THEN 0 ELSE 1 END AS R2Interviewer2HasFile,  
        ISNULL(DATALENGTH(r2.sresumefile), 0) AS R2Interviewer2FileSize,  

        CASE WHEN @IncludeFiles = 1 THEN r2.fresumefile END AS R2Interviewer1File,  
        CASE WHEN @IncludeFiles = 1 THEN r2.sresumefile END AS R2Interviewer2File,  

        /* =========================================================  
           ROUND 3  
        ========================================================= */  

        ISNULL(CONVERT(NVARCHAR(30), t.rthreeinterviewdate, 120), '') AS R3InterviewDate,  
        ISNULL(CONVERT(NVARCHAR(30), t.rthreeinterviewenddate, 120), '') AS R3InterviewEndDate,  
        ISNULL(t.rthreeinterviewernameone, '') AS R3Interviewer1,  
        ISNULL(t.rthreeinterviewernametwo, '') AS R3Interviewer2,  
        ISNULL(t.rthreeselect, '') AS R3Selected,  

        ISNULL(r3.fName, '') AS R3Interviewer1FileName,  
        ISNULL(r3.fContentType, '') AS R3Interviewer1ContentType,  
        ISNULL(r3.fRemarksText, '') AS R3Interviewer1Remarks,  
        CASE WHEN r3.fresumefile IS NULL THEN 0 ELSE 1 END AS R3Interviewer1HasFile,  
        ISNULL(DATALENGTH(r3.fresumefile), 0) AS R3Interviewer1FileSize,  

        ISNULL(r3.sName, '') AS R3Interviewer2FileName,  
        ISNULL(r3.sContentType, '') AS R3Interviewer2ContentType,  
        ISNULL(r3.sRemarksText, '') AS R3Interviewer2Remarks,  
        CASE WHEN r3.sresumefile IS NULL THEN 0 ELSE 1 END AS R3Interviewer2HasFile,  
        ISNULL(DATALENGTH(r3.sresumefile), 0) AS R3Interviewer2FileSize,  

        CASE WHEN @IncludeFiles = 1 THEN r3.fresumefile END AS R3Interviewer1File,  
        CASE WHEN @IncludeFiles = 1 THEN r3.sresumefile END AS R3Interviewer2File,  

        /* =========================================================  
           FINAL ROUND FILE DETAILS  
        ========================================================= */  

        ISNULL(rf.fName, '') AS RFInterviewer1FileName,  
        ISNULL(rf.fContentType, '') AS RFInterviewer1ContentType,  
        ISNULL(rf.fRemarksText, '') AS RFInterviewer1Remarks,  
        CASE WHEN rf.fresumefile IS NULL THEN 0 ELSE 1 END AS RFInterviewer1HasFile,  
        ISNULL(DATALENGTH(rf.fresumefile), 0) AS RFInterviewer1FileSize,  

        ISNULL(rf.sName, '') AS RFInterviewer2FileName,  
        ISNULL(rf.sContentType, '') AS RFInterviewer2ContentType,  
        ISNULL(rf.sRemarksText, '') AS RFInterviewer2Remarks,  
        CASE WHEN rf.sresumefile IS NULL THEN 0 ELSE 1 END AS RFInterviewer2HasFile,  
        ISNULL(DATALENGTH(rf.sresumefile), 0) AS RFInterviewer2FileSize,  

        CASE WHEN @IncludeFiles = 1 THEN rf.fresumefile END AS RFInterviewer1File,  
        CASE WHEN @IncludeFiles = 1 THEN rf.sresumefile END AS RFInterviewer2File,  

        ISNULL(CONVERT(NVARCHAR(30), t.createdtime, 120), '') AS createdtime,  
        ISNULL(CONVERT(NVARCHAR(30), t.modifiedtime, 120), '') AS modifiedtime  

    FROM KeyMaster k

    LEFT JOIN trecruittraker t  
        ON t.candidateid = k.candidateid OR t.Referenceno = k.Referenceno

    LEFT JOIN vw_recruittracker v  
        ON v.registrationnumber = k.Referenceno  

    LEFT JOIN trecruittrakeruploadfileone r1  
        ON r1.candidateid = k.candidateid  

    LEFT JOIN trecruittrakeruploadfiletwo r2  
        ON r2.candidateid = k.candidateid  

    LEFT JOIN trecruittrakeruploadfilethree r3  
        ON r3.candidateid = k.candidateid  

    LEFT JOIN trecruittrakeruploadfilefinal rf  
        ON rf.candidateid = k.candidateid  

    WHERE  
        (@Referenceno IS NULL OR k.Referenceno = @Referenceno)  
        AND (@CandidateID IS NULL OR k.candidateid = @CandidateID)  

    ORDER BY ISNULL(CONVERT(NVARCHAR(30), t.modifiedtime, 120), '') DESC;  
END;
GO

/* Functional group: 08_INTERVIEW; referenced grouped tables: trecruittraker, trecruittrakeruploadfilefinal, trecruittrakeruploadfileone, trecruittrakeruploadfilethree, trecruittrakeruploadfiletwo */
/****** Object:  StoredProcedure [dbo].[PRC_Save_InterviewDetails]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PRC_Save_InterviewDetails]          
(          
    @Action NVARCHAR(30),          
    @Round NVARCHAR(10),          
    @Referenceno NVARCHAR(50),          
      
    @InterviewDate DATE = NULL,          
    @InterviewEndDate DATE = NULL,          
    @Interviewer1 NVARCHAR(MAX) = NULL,          
    @Interviewer2 NVARCHAR(MAX) = NULL,          
      
    @RemarkFile1 VARBINARY(MAX) = NULL,          
    @RemarkFile2 VARBINARY(MAX) = NULL,          
    @InterviewContentType1 NVARCHAR(MAX) = NULL,          
    @InterviewContentType2 NVARCHAR(MAX) = NULL,          
    @RemarkFileName1 nvarchar(max) =null,    
 @RemarkFileName2 nvarchar(max) =null,    
    
    @RemarkText1 NVARCHAR(MAX) = NULL,   -- NEW      
    @RemarkText2 NVARCHAR(MAX) = NULL,   -- NEW      
      
    @RoundSelected NVARCHAR(MAX) = NULL,          
    @CreatedBy NVARCHAR(MAX) = NULL,          
      
    @InterviewerIndex INT = NULL        -- used by DELETE_REMARK (1 or 2)      
)          
AS          
BEGIN          
    SET NOCOUNT ON;      
      
    BEGIN TRY      
       BEGIN TRANSACTION;      
      
    DECLARE @Departmentdivision NVARCHAR(MAX),          
            @PostId BIGINT,          
            @Source NVARCHAR(MAX),          
            @Postname NVARCHAR(MAX),          
            @Locid BIGINT,          
            @CandidateID BIGINT,          
            @Candidatename NVARCHAR(MAX);      
      
    SELECT           
        @Departmentdivision = deptdivision,          
        @PostId = postid,          
        @Source = referredus,          
        @Postname = postname,          
        @Locid = locid,          
        @CandidateID = candidateid,          
        @Candidatename = CandidateName          
    FROM vw_recruittracker          
    WHERE registrationnumber = @Referenceno;      
      
    IF @Round NOT IN ('R1','R2','R3','RF') AND @Action NOT IN ('DELETE_REMARK')      
    BEGIN      
        RAISERROR('Invalid Round Specified',16,1);      
        ROLLBACK TRANSACTION;      
        RETURN;      
    END      
      
    IF (NOT EXISTS (SELECT 1 FROM trecruittraker WHERE Referenceno = @Referenceno)  AND   @Action <> 'SELECT')        
    BEGIN          
        INSERT INTO trecruittraker (Referenceno, Departmentdivision, locid, candidateid, source, candidatename, postid, Postname)          
        VALUES (@Referenceno, @Departmentdivision, @Locid, @CandidateID, @Source, @Candidatename, @PostId, @Postname);          
    END;          
      
    -- DELETE_REMARK: clear file and remark text for a specific round + interviewer (index 1 or 2)      
    IF @Action = 'DELETE_REMARK'      
    BEGIN      
        IF @Round = 'R1'      
        BEGIN      
            IF @InterviewerIndex = 1      
            BEGIN      
                UPDATE trecruittrakeruploadfileone      
                SET fContentType = NULL,      
                    fresumefile = NULL,      
                    fRemarksText = NULL,      
                    modifiedtime = GETDATE()      
                WHERE candidateid = @CandidateID;      
            END      
            ELSE IF @InterviewerIndex = 2      
            BEGIN      
                UPDATE trecruittrakeruploadfileone      
                SET sContentType = NULL,      
                    sresumefile = NULL,      
                    sRemarksText = NULL,      
                    modifiedtime = GETDATE()      
                WHERE candidateid = @CandidateID;      
            END      
        END      
        ELSE IF @Round = 'R2'      
        BEGIN      
            IF @InterviewerIndex = 1      
            BEGIN      
                UPDATE trecruittrakeruploadfiletwo      
                SET fContentType = NULL,      
                    fresumefile = NULL,      
                    fRemarksText = NULL,      
                    modifiedtime = GETDATE()      
                WHERE candidateid = @CandidateID;      
            END      
            ELSE IF @InterviewerIndex = 2      
            BEGIN      
                UPDATE trecruittrakeruploadfiletwo      
                SET sContentType = NULL,      
                    sresumefile = NULL,      
                    sRemarksText = NULL,      
                    modifiedtime = GETDATE()      
                WHERE candidateid = @CandidateID;      
            END      
        END      
        ELSE IF @Round = 'R3'      
        BEGIN      
            IF @InterviewerIndex = 1      
            BEGIN      
                UPDATE trecruittrakeruploadfilethree      
                SET fContentType = NULL,      
                  fresumefile = NULL,      
                    fRemarksText = NULL,      
                    modifiedtime = GETDATE()      
                WHERE candidateid = @CandidateID;      
            END      
            ELSE IF @InterviewerIndex = 2      
            BEGIN      
                UPDATE trecruittrakeruploadfilethree      
                SET sContentType = NULL,      
                    sresumefile = NULL,      
                    sRemarksText = NULL,      
                    modifiedtime = GETDATE()      
                WHERE candidateid = @CandidateID;      
            END      
        END      
        ELSE IF @Round = 'RF'      
        BEGIN      
            IF @InterviewerIndex = 1      
            BEGIN      
                UPDATE trecruittrakeruploadfilefinal      
                SET fContentType = NULL,      
                    fresumefile = NULL,      
                    fRemarksText = NULL,      
                    modifiedtime = GETDATE()      
                WHERE candidateid = @CandidateID;      
            END      
            ELSE IF @InterviewerIndex = 2      
            BEGIN      
                UPDATE trecruittrakeruploadfilefinal      
                SET sContentType = NULL,      
                    sresumefile = NULL,      
                    sRemarksText = NULL,      
                    modifiedtime = GETDATE()      
                WHERE candidateid = @CandidateID;      
            END      
        END      
      
        COMMIT TRANSACTION;      
        RETURN;      
    END      
      
    ---------------------------------------------------      
    -- R1      
    ---------------------------------------------------      
    IF @Round = 'R1'      
    BEGIN      
        IF @Action = 'INSERT'      
        BEGIN      
            INSERT INTO trecruittrakeruploadfileone      
            (candidateid, postid, locid,      
             fName, fContentType, fresumefile,fRemarksText,
			 sName, sContentType,sresumefile, sRemarksText, 
			 createdtime)      
            VALUES      
            (@CandidateID, @PostId, @Locid,      
             @RemarkFileName1, @InterviewContentType1, @RemarkFile1, @RemarkText1,      
             @RemarkFileName2, @InterviewContentType2, @RemarkFile2, @RemarkText2, GETDATE());      
        END      
        ELSE IF @Action = 'UPDATE'      
        BEGIN      
			IF  EXISTS (Select * from trecruittrakeruploadfileone WHERE candidateid = @CandidateID)
			  BEGIN
					 UPDATE trecruittrakeruploadfileone
						SET 
							fName = CASE WHEN @RemarkFileName1 IS NOT NULL THEN @RemarkFileName1 ELSE fName END,
							fContentType = CASE WHEN @InterviewContentType1 IS NOT NULL THEN @InterviewContentType1 ELSE fContentType END,
							fresumefile = CASE WHEN @RemarkFile1 IS NOT NULL THEN @RemarkFile1 ELSE fresumefile END,
							fRemarksText = CASE WHEN @RemarkText1 IS NOT NULL THEN @RemarkText1 ELSE fRemarksText END,

							sName = CASE WHEN @RemarkFileName2 IS NOT NULL THEN @RemarkFileName2 ELSE sName END,
							sContentType = CASE WHEN @InterviewContentType2 IS NOT NULL THEN @InterviewContentType2 ELSE sContentType END,
							sresumefile = CASE WHEN @RemarkFile2 IS NOT NULL THEN @RemarkFile2 ELSE sresumefile END,
							sRemarksText = CASE WHEN @RemarkText2 IS NOT NULL THEN @RemarkText2 ELSE sRemarksText END,

							modifiedtime = GETDATE()
						WHERE candidateid = @CandidateID;
			 END
			 ELSE
			  BEGIN
			       INSERT INTO trecruittrakeruploadfileone      
					(candidateid, postid, locid,      
					 fName, fContentType, fresumefile,fRemarksText,
					 sName, sContentType,sresumefile, sRemarksText, 
					 createdtime)      
					VALUES      
					(@CandidateID, @PostId, @Locid,      
					 @RemarkFileName1, @InterviewContentType1, @RemarkFile1, @RemarkText1,      
					 @RemarkFileName2, @InterviewContentType2, @RemarkFile2, @RemarkText2, GETDATE());   
			  END
            --UPDATE trecruittrakeruploadfileone      
            --SET fName = @RemarkFileName1,      
            --    fContentType = CASE WHEN @InterviewContentType1 IS NOT NULL THEN @InterviewContentType1 ELSE fContentType END,      
            --    fresumefile = CASE WHEN @RemarkFile1 IS NOT NULL THEN @RemarkFile1 ELSE fresumefile END,      
            --    fRemarksText = CASE WHEN @RemarkText1 IS NOT NULL THEN @RemarkText1 ELSE fRemarksText END,      
            --    sName = @RemarkFileName2,      
            --    sContentType = CASE WHEN @InterviewContentType2 IS NOT NULL THEN @InterviewContentType2 ELSE sContentType END,      
            --    sresumefile = CASE WHEN @RemarkFile2 IS NOT NULL THEN @RemarkFile2 ELSE sresumefile END,      
            --    sRemarksText = CASE WHEN @RemarkText2 IS NOT NULL THEN @RemarkText2 ELSE sRemarksText END,      
            --    modifiedtime = GETDATE()      
            --WHERE candidateid = @CandidateID;      
        END      
      
        IF @Action IN ('INSERT','UPDATE')      
        BEGIN      
            UPDATE trecruittraker      
            SET roneinterviewdate = @InterviewDate,      
                roneinterviewenddate = @InterviewEndDate,      
                roneinterviewernameone = @Interviewer1,      
                roneinterviewernametwo = @Interviewer2,      
                roneselect = @RoundSelected,      
                modifiedtime = GETDATE()      
            WHERE Referenceno = @Referenceno;      
        END      
      
       IF @Action = 'SELECT'      
        BEGIN      
            SELECT t.Referenceno, t.candidateid, t.candidatename, t.postid, t.Postname,      
                   t.locid, t.Departmentdivision, t.source,      
                   t.roneinterviewdate AS InterviewDate,      
                   t.roneinterviewenddate AS InterviewEndDate,      
                   t.roneinterviewernameone AS Interviewer1,      
                   t.roneinterviewernametwo AS Interviewer2,      
                   t.roneselect AS RoundSelected,      
                   u.fRemarksText AS Interviewer1RemarksText,      
                   u.sRemarksText AS Interviewer2RemarksText,      
                   u.fContentType AS Interviewer1FileType,      
                   u.sContentType AS Interviewer2FileType,      
                   CASE WHEN u.fresumefile IS NULL THEN 0 ELSE 1 END AS Interviewer1HasFile,      
                   CASE WHEN u.sresumefile IS NULL THEN 0 ELSE 1 END AS Interviewer2HasFile      
            FROM trecruittraker t      
            LEFT JOIN trecruittrakeruploadfileone u ON u.candidateid = t.candidateid      
            WHERE t.Referenceno = @Referenceno      
              AND t.candidateid = @CandidateID;      
        END      
    END      
      
    ---------------------------------------------------      
    -- R2      
    ---------------------------------------------------      
    ELSE IF @Round = 'R2'      
    BEGIN      
        -- same pattern: INSERT / UPDATE / SELECT but using trecruittrakeruploadfiletwo      
        IF @Action = 'INSERT'      
        BEGIN      
            INSERT INTO trecruittrakeruploadfiletwo      
            (candidateid, postid, locid,      
             fName, fContentType, fresumefile, fRemarksText,      
             sName, sContentType, sresumefile, sRemarksText, createdtime)      
            VALUES      
            (@CandidateID, @PostId, @Locid,      
             @RemarkFileName1, @InterviewContentType1, @RemarkFile1, @RemarkText1,      
             @RemarkFileName2, @InterviewContentType2, @RemarkFile2, @RemarkText2, GETDATE());      
        END      
        ELSE IF @Action = 'UPDATE'      
        BEGIN    
		     IF  EXISTS (Select * from trecruittrakeruploadfiletwo WHERE candidateid = @CandidateID)
			  BEGIN
		       UPDATE trecruittrakeruploadfiletwo
				SET 
					fName = CASE WHEN @RemarkFileName1 IS NOT NULL THEN @RemarkFileName1 ELSE fName END,
					fContentType = CASE WHEN @InterviewContentType1 IS NOT NULL THEN @InterviewContentType1 ELSE fContentType END,
					fresumefile = CASE WHEN @RemarkFile1 IS NOT NULL THEN @RemarkFile1 ELSE fresumefile END,
					fRemarksText = CASE WHEN @RemarkText1 IS NOT NULL THEN @RemarkText1 ELSE fRemarksText END,

					sName = CASE WHEN @RemarkFileName2 IS NOT NULL THEN @RemarkFileName2 ELSE sName END,
					sContentType = CASE WHEN @InterviewContentType2 IS NOT NULL THEN @InterviewContentType2 ELSE sContentType END,
					sresumefile = CASE WHEN @RemarkFile2 IS NOT NULL THEN @RemarkFile2 ELSE sresumefile END,
					sRemarksText = CASE WHEN @RemarkText2 IS NOT NULL THEN @RemarkText2 ELSE sRemarksText END,

					modifiedtime = GETDATE()
				WHERE candidateid = @CandidateID;
			END
			ELSE
			BEGIN
			   INSERT INTO trecruittrakeruploadfiletwo      
				(candidateid, postid, locid,      
				 fName, fContentType, fresumefile, fRemarksText,      
				 sName, sContentType, sresumefile, sRemarksText, createdtime)      
				VALUES      
				(@CandidateID, @PostId, @Locid,      
				 @RemarkFileName1, @InterviewContentType1, @RemarkFile1, @RemarkText1,      
				 @RemarkFileName2, @InterviewContentType2, @RemarkFile2, @RemarkText2, GETDATE());      
			END
            --UPDATE trecruittrakeruploadfiletwo      
            --SET fName = @RemarkFileName1,      
            --    fContentType = CASE WHEN @InterviewContentType1 IS NOT NULL THEN @InterviewContentType1 ELSE fContentType END,      
            --    fresumefile = CASE WHEN @RemarkFile1 IS NOT NULL THEN @RemarkFile1 ELSE fresumefile END,      
            --    fRemarksText = CASE WHEN @RemarkText1 IS NOT NULL THEN @RemarkText1 ELSE fRemarksText END,      
            --    sName = @RemarkFileName2,      
            --    sContentType = CASE WHEN @InterviewContentType2 IS NOT NULL THEN @InterviewContentType2 ELSE sContentType END,      
            --    sresumefile = CASE WHEN @RemarkFile2 IS NOT NULL THEN @RemarkFile2 ELSE sresumefile END,      
            --    sRemarksText = CASE WHEN @RemarkText2 IS NOT NULL THEN @RemarkText2 ELSE sRemarksText END,      
            --    modifiedtime = GETDATE()      
            --WHERE candidateid = @CandidateID;      
        END      
      
        IF @Action IN ('INSERT','UPDATE')      
        BEGIN      
            UPDATE trecruittraker      
            SET rtwointerviewdate = @InterviewDate,      
                rtwointerviewenddate = @InterviewEndDate,      
                rtwointerviewernameone = @Interviewer1,      
                rtwointerviewernametwo = @Interviewer2,      
                rtwoselect = @RoundSelected,      
                modifiedtime = GETDATE()      
            WHERE Referenceno = @Referenceno;      
        END      
      
        IF @Action = 'SELECT'      
        BEGIN      
            SELECT t.Referenceno, t.candidateid, t.candidatename, t.postid, t.Postname,      
                   t.locid, t.Departmentdivision, t.source,      
                   t.rtwointerviewdate AS InterviewDate,      
                   t.rtwointerviewenddate AS InterviewEndDate,      
                   t.rtwointerviewernameone AS Interviewer1,      
                   t.rtwointerviewernametwo AS Interviewer2,      
      t.rtwoselect AS RoundSelected,      
                   u.fRemarksText AS Interviewer1RemarksText,      
                   u.sRemarksText AS Interviewer2RemarksText,      
                   u.fContentType AS Interviewer1FileType,      
                   u.sContentType AS Interviewer2FileType,      
                   CASE WHEN u.fresumefile IS NULL THEN 0 ELSE 1 END AS Interviewer1HasFile,      
                   CASE WHEN u.sresumefile IS NULL THEN 0 ELSE 1 END AS Interviewer2HasFile      
            FROM trecruittraker t      
            LEFT JOIN trecruittrakeruploadfiletwo u ON u.candidateid = t.candidateid      
            WHERE t.Referenceno = @Referenceno      
     AND t.candidateid = @CandidateID;      
        END      
    END      
      
    ---------------------------------------------------      
    -- R3      
    ---------------------------------------------------      
    ELSE IF @Round = 'R3'      
    BEGIN      
        IF @Action = 'INSERT'      
        BEGIN      
            INSERT INTO trecruittrakeruploadfilethree      
            (candidateid, postid, locid,      
             fName, fContentType, fresumefile, fRemarksText,      
             sName, sContentType, sresumefile, sRemarksText, createdtime)      
            VALUES      
            (@CandidateID, @PostId, @Locid,      
             @RemarkFileName1, @InterviewContentType1, @RemarkFile1, @RemarkText1,      
             @RemarkFileName2, @InterviewContentType2, @RemarkFile2, @RemarkText2, GETDATE());      
        END      
        ELSE IF @Action = 'UPDATE'      
        BEGIN   
		   IF  EXISTS (Select * from trecruittrakeruploadfilethree WHERE candidateid = @CandidateID)
			  BEGIN
				 UPDATE trecruittrakeruploadfilethree
					SET 
						fName = CASE WHEN @RemarkFileName1 IS NOT NULL THEN @RemarkFileName1 ELSE fName END,
						fContentType = CASE WHEN @InterviewContentType1 IS NOT NULL THEN @InterviewContentType1 ELSE fContentType END,
						fresumefile = CASE WHEN @RemarkFile1 IS NOT NULL THEN @RemarkFile1 ELSE fresumefile END,
						fRemarksText = CASE WHEN @RemarkText1 IS NOT NULL THEN @RemarkText1 ELSE fRemarksText END,

						sName = CASE WHEN @RemarkFileName2 IS NOT NULL THEN @RemarkFileName2 ELSE sName END,
						sContentType = CASE WHEN @InterviewContentType2 IS NOT NULL THEN @InterviewContentType2 ELSE sContentType END,
						sresumefile = CASE WHEN @RemarkFile2 IS NOT NULL THEN @RemarkFile2 ELSE sresumefile END,
						sRemarksText = CASE WHEN @RemarkText2 IS NOT NULL THEN @RemarkText2 ELSE sRemarksText END,

						modifiedtime = GETDATE()
					WHERE candidateid = @CandidateID;
			 END
			 ELSE 
			 BEGIN
			     INSERT INTO trecruittrakeruploadfilethree      
				(candidateid, postid, locid,      
				 fName, fContentType, fresumefile, fRemarksText,      
				 sName, sContentType, sresumefile, sRemarksText, createdtime)      
				VALUES      
				(@CandidateID, @PostId, @Locid,      
				 @RemarkFileName1, @InterviewContentType1, @RemarkFile1, @RemarkText1,      
				 @RemarkFileName2, @InterviewContentType2, @RemarkFile2, @RemarkText2, GETDATE());    
			 END
            --UPDATE trecruittrakeruploadfilethree      
            --SET fName = @RemarkFileName1,      
            --    fContentType = CASE WHEN @InterviewContentType1 IS NOT NULL THEN @InterviewContentType1 ELSE fContentType END,      
            --    fresumefile = CASE WHEN @RemarkFile1 IS NOT NULL THEN @RemarkFile1 ELSE fresumefile END,      
            --    fRemarksText = CASE WHEN @RemarkText1 IS NOT NULL THEN @RemarkText1 ELSE fRemarksText END,      
            --    sName = @RemarkFileName2,      
            --    sContentType = CASE WHEN @InterviewContentType2 IS NOT NULL THEN @InterviewContentType2 ELSE sContentType END,      
            --    sresumefile = CASE WHEN @RemarkFile2 IS NOT NULL THEN @RemarkFile2 ELSE sresumefile END,      
            --    sRemarksText = CASE WHEN @RemarkText2 IS NOT NULL THEN @RemarkText2 ELSE sRemarksText END,      
            --    modifiedtime = GETDATE()      
            --WHERE candidateid = @CandidateID;      
        END      
      
        IF @Action IN ('INSERT','UPDATE')      
        BEGIN      
            UPDATE trecruittraker      
            SET rthreeinterviewdate = @InterviewDate,      
                rthreeinterviewenddate = @InterviewEndDate,      
                rthreeinterviewernameone = @Interviewer1,      
                rthreeinterviewernametwo = @Interviewer2,      
                rthreeselect = @RoundSelected,      
                modifiedtime = GETDATE()      
            WHERE Referenceno = @Referenceno;      
        END      
      
        IF @Action = 'SELECT'      
        BEGIN      
            SELECT t.Referenceno, t.candidateid, t.candidatename, t.postid, t.Postname,      
                   t.locid, t.Departmentdivision, t.source,      
                   t.rthreeinterviewdate AS InterviewDate,      
                   t.rthreeinterviewenddate AS InterviewEndDate,      
                   t.rthreeinterviewernameone AS Interviewer1,      
                   t.rthreeinterviewernametwo AS Interviewer2,      
                   t.rthreeselect AS RoundSelected,      
                   u.fRemarksText AS Interviewer1RemarksText,      
                   u.sRemarksText AS Interviewer2RemarksText,      
                   u.fContentType AS Interviewer1FileType,      
                   u.sContentType AS Interviewer2FileType,      
                   CASE WHEN u.fresumefile IS NULL THEN 0 ELSE 1 END AS Interviewer1HasFile,      
                   CASE WHEN u.sresumefile IS NULL THEN 0 ELSE 1 END AS Interviewer2HasFile      
            FROM trecruittraker t      
            LEFT JOIN trecruittrakeruploadfilethree u ON u.candidateid = t.candidateid      
            WHERE t.Referenceno = @Referenceno      
              AND t.candidateid = @CandidateID;      
        END      
    END      
      
    ---------------------------------------------------      
    -- RF (FINAL)      
    ---------------------------------------------------      
    ELSE IF @Round = 'RF'      
    BEGIN      
        IF @Action = 'INSERT'      
        BEGIN      
            INSERT INTO trecruittrakeruploadfilefinal      
            (candidateid, postid, locid,      
             fName, fContentType, fresumefile, fRemarksText,      
             sName, sContentType, sresumefile, sRemarksText, createdtime)      
            VALUES      
            (@CandidateID, @PostId, @Locid,      
             @RemarkFileName1, @InterviewContentType1, @RemarkFile1, @RemarkText1,      
             @RemarkFileName2, @InterviewContentType2, @RemarkFile2, @RemarkText2, GETDATE());      
        END      
        ELSE IF @Action = 'UPDATE'      
        BEGIN      
		IF  EXISTS (Select * from trecruittrakeruploadfilefinal WHERE candidateid = @CandidateID)
			  BEGIN
			 UPDATE trecruittrakeruploadfilefinal
				SET 
					fName = CASE WHEN @RemarkFileName1 IS NOT NULL THEN @RemarkFileName1 ELSE fName END,
					fContentType = CASE WHEN @InterviewContentType1 IS NOT NULL THEN @InterviewContentType1 ELSE fContentType END,
					fresumefile = CASE WHEN @RemarkFile1 IS NOT NULL THEN @RemarkFile1 ELSE fresumefile END,
					fRemarksText = CASE WHEN @RemarkText1 IS NOT NULL THEN @RemarkText1 ELSE fRemarksText END,

					sName = CASE WHEN @RemarkFileName2 IS NOT NULL THEN @RemarkFileName2 ELSE sName END,
					sContentType = CASE WHEN @InterviewContentType2 IS NOT NULL THEN @InterviewContentType2 ELSE sContentType END,
					sresumefile = CASE WHEN @RemarkFile2 IS NOT NULL THEN @RemarkFile2 ELSE sresumefile END,
					sRemarksText = CASE WHEN @RemarkText2 IS NOT NULL THEN @RemarkText2 ELSE sRemarksText END,

					modifiedtime = GETDATE()
				WHERE candidateid = @CandidateID;
				END
				ELSE
				BEGIN
						   INSERT INTO trecruittrakeruploadfilefinal      
					(candidateid, postid, locid,      
					 fName, fContentType, fresumefile, fRemarksText,      
					 sName, sContentType, sresumefile, sRemarksText, createdtime)      
					VALUES      
					(@CandidateID, @PostId, @Locid,      
					 @RemarkFileName1, @InterviewContentType1, @RemarkFile1, @RemarkText1,      
					 @RemarkFileName2, @InterviewContentType2, @RemarkFile2, @RemarkText2, GETDATE());     
				END
            --UPDATE trecruittrakeruploadfilefinal      
            --SET fName = @RemarkFileName1,      
            --    fContentType = CASE WHEN @InterviewContentType1 IS NOT NULL THEN @InterviewContentType1 ELSE fContentType END,      
            --    fresumefile = CASE WHEN @RemarkFile1 IS NOT NULL THEN @RemarkFile1 ELSE fresumefile END,      
            --    fRemarksText = CASE WHEN @RemarkText1 IS NOT NULL THEN @RemarkText1 ELSE fRemarksText END,      
            --    sName = @RemarkFileName2,      
            --    sContentType = CASE WHEN @InterviewContentType2 IS NOT NULL THEN @InterviewContentType2 ELSE sContentType END,      
            --    sresumefile = CASE WHEN @RemarkFile2 IS NOT NULL THEN @RemarkFile2 ELSE sresumefile END,      
            --    sRemarksText = CASE WHEN @RemarkText2 IS NOT NULL THEN @RemarkText2 ELSE sRemarksText END,      
            --    modifiedtime = GETDATE()      
            --WHERE candidateid = @CandidateID;      
        END      
      
        IF @Action IN ('INSERT','UPDATE')      
        BEGIN      
            UPDATE trecruittraker      
            SET frinterviewdate = @InterviewDate,      
                frinterviewenddate = @InterviewEndDate,      
                frinterviewernameone = @Interviewer1,      
                frinterviewernametwo = @Interviewer2,      
                frselect = @RoundSelected,      
                modifiedtime = GETDATE()      
            WHERE Referenceno = @Referenceno;      
        END      
      
        IF @Action = 'SELECT'      
        BEGIN      
            SELECT t.Referenceno, t.candidateid, t.candidatename, t.postid, t.Postname,      
                   t.locid, t.Departmentdivision, t.source,      
                   t.frinterviewdate AS InterviewDate,      
                   t.frinterviewenddate AS InterviewEndDate,      
                   t.frinterviewernameone AS Interviewer1,      
                   t.frinterviewernametwo AS Interviewer2,      
                   t.frselect AS RoundSelected,      
                   u.fRemarksText AS Interviewer1RemarksText,      
                   u.sRemarksText AS Interviewer2RemarksText,      
                   u.fContentType AS Interviewer1FileType,      
                   u.sContentType AS Interviewer2FileType,      
  CASE WHEN u.fresumefile IS NULL THEN 0 ELSE 1 END AS Interviewer1HasFile,      
                   CASE WHEN u.sresumefile IS NULL THEN 0 ELSE 1 END AS Interviewer2HasFile      
            FROM trecruittraker t      
            LEFT JOIN trecruittrakeruploadfilefinal u ON u.candidateid = t.candidateid      
            WHERE t.Referenceno = @Referenceno      
              AND t.candidateid = @CandidateID;      
        END      
    END      
      
    COMMIT TRANSACTION;      
    END TRY      
    BEGIN CATCH      
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;      
        THROW;      
    END CATCH;      
      
END     
GO

/* Functional group: 08_INTERVIEW; referenced grouped tables: Tbl_Interview_Taken_Details, trecruitcanbasicdtls */
/****** Object:  StoredProcedure [dbo].[proc_GetInterviewerDtls_Feedback]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[proc_GetInterviewerDtls_Feedback]          
@Id int=null,        
@Cand_Regno varchar(max),          
@Action varchar(max),          
@InterviewTaken_DeptID int=null,          
@InterviewTaken_PersonID int =null,          
@InterviewRound int =null,          
@Interview_Remarks varchar(max)=null          
as                
begin                
                
    DECLARE @candidateid INT;                
 SELECT @candidateid = candidateid                         
    FROM trecruitcanbasicdtls                         
    WHERE registrationnumber = @Cand_Regno;               
           
          
       IF @candidateid IS NULL          
    BEGIN          
        PRINT 'Candidate not found.';          
        RETURN;          
    END          
          
          
       IF @Action = 'Select'          
    BEGIN          
                 
 SELECT        
 intdtls.Id,      
    intdtls.Cand_regno,                
    CndDtls.firstname + ' ' + ISNULL(CndDtls.middlename + ' ', '') + CndDtls.lastname AS CandidateFullName,              
    emp1.empfirstname + ' ' + ISNULL(emp1.empmiddlename + ' ', '') + emp1.emplastname   AS InterviewerName ,
	intdtls.InterviewTaken_PersonId,
	dept1.Department as InterviewerDept,
	intdtls.InterviewTaken_DeptID,
	intdtls.InterviewRound,            
	intdtls.Interview_Remarks   
               
    --'[ ' + emp1.empfirstname + ' ' + ISNULL(emp1.empmiddlename + ' ', '') + emp1.emplastname + ' - ' + dept1.Department + ' ]' AS R1_interviewerNameDept,                
    --'[ ' + emp2.empfirstname + ' ' + ISNULL(emp2.empmiddlename + ' ', '') + emp2.emplastname + ' - ' + dept2.Department + ' ]' AS R2_interviewerNameDept,                
    --'[ ' + emp3.empfirstname + ' ' + ISNULL(emp3.empmiddlename + ' ', '') + emp3.emplastname + ' - ' + dept3.Department + ' ]' AS R3_interviewerNameDept,                
    --'[ ' + emp4.empfirstname + ' ' + ISNULL(emp4.empmiddlename + ' ', '') + emp4.emplastname + ' - ' + dept4.Department + ' ]' AS R4_interviewerNameDept                
FROM                 
    Tbl_Interview_Taken_Details AS intdtls                
LEFT JOIN                 
    essp.dbo.Empbasic AS emp1 ON intdtls.InterviewTaken_PersonID = emp1.empid                
LEFT JOIN                 
    essp.dbo.Department AS dept1 ON intdtls.InterviewTaken_DeptID = dept1.DepartmentId                
               
INNER JOIN                 
    vw_rcalldata AS a ON a.registrationnumber = intdtls.Cand_regno                
INNER JOIN                 
    trecruitcanbasicdtls AS CndDtls ON intdtls.Cand_regno = CndDtls.registrationnumber                
 WHERE intdtls.Cand_regno = @Cand_Regno;           
           
END          
    IF @Action = 'Update'          
    BEGIN          
        PRINT 'Updating record for Cand_Regno: ' + @Cand_Regno + ' and Id: ' + CAST(@Id AS VARCHAR);  -- Debugging line      
              
        UPDATE Tbl_Interview_Taken_Details          
        SET       
            InterviewTaken_DeptID = @InterviewTaken_DeptID,          
            InterviewTaken_PersonID = @InterviewTaken_PersonID,          
            Interview_Remarks = @Interview_Remarks,          
            InterviewRound = @InterviewRound          
        WHERE       
            Cand_Regno = @Cand_Regno AND Id = @Id;          
      
        -- Check if update was successful      
        IF @@ROWCOUNT = 0      
        BEGIN      
            PRINT 'No record found to update.';      
        END      
      ELSE      
        BEGIN      
            PRINT 'Update successful.';      
        END      
    END                 
          
          
end
GO

/* Functional group: 08_INTERVIEW; referenced grouped tables: Tbl_Interview_Taken_Details, trecruitcanbasicdtls */
/****** Object:  StoredProcedure [dbo].[Proc_GetRecruitmentRecordTrackerOnProcess]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Proc_GetRecruitmentRecordTrackerOnProcess]      
@Cand_Regno VARCHAR(MAX)=null ,
@CanBackgroundVerification varchar(max)=null,
@CanSelectionStatus varchar(max)=null,
@Action varchar(20) =null
as      
begin      
      
  
 if @Cand_Regno is null  
 begin  
SELECT     
    
    rqt.registrationnumber,      
    rqt.aplicationdate,      
     CAST(YEAR(convert( Datetime,rqt.aplicationdate,103)) AS VARCHAR(4)) + '-' + LEFT(DATENAME(MONTH, convert( Datetime,rqt.aplicationdate,103)), 3) AS YearMonth,      
    ((DAY(convert( Datetime,rqt.aplicationdate,103)) - 1) / 7) + 1 AS WeekNumber,      
    rqt.candidateid,      
    rqt.CandidateName,      
    rqt.postname,      
    rqt.postid,      
    rqt.deptdivision,      
    rqt.location,      
    rqt.locid,      
    rqt.deptname,      
    STRING_AGG('[ ' + emp.empfirstname + ' ' + ISNULL(emp.empmiddlename + ' ', '') + emp.emplastname + ' - ' + dept.Department + ' ]', ', ') AS InterviewerName_Dept  ,
	canbasic.CanBackgroundVerification,
	canbasic.CanSelectionStatus
FROM       
    [vw_Recruitment_Tracker] AS rqt      
LEFT JOIN       
    Tbl_Interview_Taken_Details AS intdtls ON intdtls.Cand_Regno = rqt.registrationnumber      
LEFT JOIN       
    essp.dbo.Empbasic AS emp ON intdtls.InterviewTaken_PersonID = emp.empid      
LEFT JOIN       
    essp.dbo.Department AS dept ON intdtls.InterviewTaken_DeptID = dept.DepartmentId  
left join trecruitcanbasicdtls as canbasic on rqt.registrationnumber=canbasic.registrationnumber
 WHERE 
    CONVERT(DATE, rqt.aplicationdate, 103) >= DATEADD(DAY, -7, GETDATE())
 --where rqt.registrationnumber='Candidate004559'    
GROUP BY       
    rqt.registrationnumber,      
    rqt.aplicationdate,      
    rqt.candidateid,      
    rqt.CandidateName,      
    rqt.postname,      
    rqt.postid,      
    rqt.deptdivision,      
    rqt.location,      
    rqt.locid,      
    rqt.deptname,
	canbasic.CanBackgroundVerification,
	canbasic.CanSelectionStatus;
	
    end  
 else if @Cand_Regno is not null  
 begin  
 select registrationnumber,candidateid,CandidateName,postname,deptname,deptdivision from [vw_recruittracker]  
 where registrationnumber=@Cand_Regno  
 end  
    
	

	if @Action='Update'
	begin
	update trecruitcanbasicdtls
	set CanSelectionStatus=@CanSelectionStatus,
		CanBackgroundVerification=@CanBackgroundVerification
	where registrationnumber=@Cand_Regno
	end
		

end      
GO

/* Functional group: 08_INTERVIEW; referenced grouped tables: Tbl_Interview_Taken_Details */
/****** Object:  StoredProcedure [dbo].[Proc_GetSelectedDepartmentById]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Proc_GetSelectedDepartmentById]           
    @id int = NULL           
    --@Action VARCHAR(20)            
AS            
BEGIN         
      
        SELECT distinct            
            dept.Department ,           
            dept.DepartmentId      
         
            --emp.empfirstname + ' ' + ISNULL(emp.empmiddlename + ' ', '') + emp.emplastname AS EmployeeName,            
            --emp.empid            
        FROM Tbl_Interview_Taken_Details as Intdtl      
  inner join essp.dbo.Department as dept      
  on dept.DepartmentId =Intdtl.InterviewTaken_DeptID     
  where Intdtl.id=@id      
        
      
   
      
end
GO

/* Functional group: 08_INTERVIEW; referenced grouped tables: tbl_Tracker_InterviewTaken_Details, tbl_Tracker_Status_Details */
/****** Object:  StoredProcedure [dbo].[proc_InterviewTaken_Details]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[proc_InterviewTaken_Details]                              
@Action VARCHAR(50),                              
@Plmapid VARCHAR(max)=null,        
      
@interviewYearMonth nvarchar(max)=null,      
@interviewWeekNumber nvarchar(max)=null,      
      
@id nvarchar(max)=null,                              
@interviewTakenId nvarchar(max)=null,                              
@candidatesName nvarchar(max)=null,                              
@TInerviewDtls Interviewer_DetailsTableType READONLY,                               
                              
@CandidatesPsychometryReport varchar(max)=null,                             
@CandidateBackgroundVerificationReport varchar(max)=null,                             
@CandidateChallenges varchar(max)=null,                             
@Remarks varchar(max)=null,                             
@CandidateStatus varchar(max)=null                              
AS                                         
BEGIN                                          
     IF @Action = 'INSERT'                                          
 BEGIN                                           
 begin try                            
 begin tran         
         
 declare @CreatedDate datetime;        
  declare @UpdatedDate datetime;        
        
  set @CreatedDate =getdate()        
  set @UpdatedDate =getdate()        
 if exists (select * from tbl_Tracker_InterviewTaken_Details where Plmapid in(select Plmapid from @TInerviewDtls))        
 begin        
   select @CreatedDate=CreatedDate from tbl_Tracker_InterviewTaken_Details        
 end        
        
   --select * from tbl_Tracker_InterviewTaken_Details  
  
    --DELETE FROM tbl_Tracker_InterviewTaken_Details                           
    --WHERE Plmapid in (SELECT Plmapid FROM @TInerviewDtls) and InterviewWeekNumber in (SELECT InterviewWeekNumber FROM @TInerviewDtls) ;                
                 
--      InterviewYearMonth  
--Jan-2025  
  
    DELETE t  
 FROM tbl_Tracker_InterviewTaken_Details t  
 INNER JOIN @TInerviewDtls d  
    ON t.Plmapid = d.Plmapid  
    AND t.InterviewWeekNumber = @interviewWeekNumber  
 AND t.InterviewYearMonth=@interviewYearMonth  
  
   
 INSERT INTO tbl_Tracker_InterviewTaken_Details              
 (Plmapid, CandidatesName, InterviewTakenId,CandidatesPsychometryReport,CandidateBackgroundVerificationReport,ChallengesName,Remarks,CandidateStatus,CreatedDate,UpdatedDate,InterviewYearMonth,InterviewWeekNumber)                                         
   SELECT Plmapid,              
   CandidatesName,               
   InterviewTakenId              
   ,CandidatesPsychometryReport              
   ,CandidateBackgroundVerificationReport              
   ,ChallengesName              
   ,Remarks              
   ,CandidateStatus        
   ,@CreatedDate        
   ,@UpdatedDate      
   ,@interviewYearMonth      
   ,@interviewWeekNumber      
   FROM @TInerviewDtls                   
 COMMIT tran;                           
 END TRY                               
 BEGIN CATCH                            
 ROLLBACK tran;                              
 THROW;                             
 END CATCH                             
                            
                              
 End                              
   IF @Action = 'SELECT'                     
  BEGIN                               
                                   
    Select candi.Id,candi.Plmapid,candi.CandidatesName,candi.InterviewTakenId,(emp.empfirstname+' '+emp.empmiddlename+' '+emp.emplastname)InterviewerName                              
   ,emp.empdept,Department         
  from tbl_Tracker_InterviewTaken_Details candi                              
  Inner join  essp.dbo.Empbasic emp on emp.empno = candi.InterviewTakenId                              
  Inner join  essp.dbo.Department dept on emp.empdept=dept.DepartmentId                              
  where candi.Plmapid=@Plmapid AND candi.InterviewYearMonth=@interviewYearMonth AND candi.InterviewWeekNumber=@interviewWeekNumber;        
  --new                              
                               
  END                              
 IF @Action = 'GET_CANDIDATES'                                          
   BEGIN                              
   SELECT                               
  candi.CandidatesName                              
   FROM                               
    tbl_Tracker_InterviewTaken_Details candi                              
    where candi.Plmapid=@Plmapid AND candi.InterviewYearMonth=@interviewYearMonth AND candi.InterviewWeekNumber=@interviewWeekNumber                        
   GROUP BY                               
    candi.CandidatesName                              
                              
 END          
 --Department           
 IF @Action = 'GET_INTERVIEW_TAKEN_DEPARTMENT'                                          
   BEGIN                              
    Select emp.empdept                              
    from tbl_Tracker_InterviewTaken_Details candi                              
    Inner join  essp.dbo.Empbasic emp on emp.empno = candi.InterviewTakenId                              
    Inner join  essp.dbo.Department dept on emp.empdept=dept.DepartmentId                              
    where candi.Plmapid=@Plmapid  AND candi.InterviewYearMonth=@interviewYearMonth AND candi.InterviewWeekNumber=@interviewWeekNumber                            
    GROUP BY                               
       emp.empdept                              
 end                               
 IF @Action = 'GET_INTERVIEW_TAKEN_ID'                             
   BEGIN                              
      SELECT candi.InterviewTakenId FROM                               
     tbl_Tracker_InterviewTaken_Details candi                              
     where candi.Plmapid=@Plmapid AND candi.InterviewYearMonth=@interviewYearMonth AND candi.InterviewWeekNumber=@interviewWeekNumber                             
     GROUP BY                               
        candi.InterviewTakenId                              
   END                              
                              
   --tbl_Tracker_Status_Details                              
   IF @Action = 'GET_Tracker_Status_Details'                                          
   BEGIN                              
    select                               
     Top 1                              
     CandidatesPsychometryReport,                              
     CandidateBackgroundVerificationReport,                              
     ChallengesName,                              
     Remarks,                              
     CandidateStatus                              
     from tbl_Tracker_InterviewTaken_Details where Plmapid= @Plmapid           
  AND InterviewYearMonth=@interviewYearMonth AND InterviewWeekNumber=@interviewWeekNumber      
   -- select * from tbl_Tracker_InterviewTaken_Details              
                   
   end                              
   IF @Action = 'UPDATE'                                          
  BEGIN                               
    Update tbl_Tracker_InterviewTaken_Details                               
    set CandidatesName=@candidatesName,InterviewTakenId=@interviewTakenId                               
    where Id=@id    AND InterviewYearMonth=@interviewYearMonth AND InterviewWeekNumber=@interviewWeekNumber                          
  End                              
 If @Action='DELETE'                              
 BEGIN                              
  DELETE tbl_Tracker_InterviewTaken_Details   where Id=@id                              
 END                              
                            
End   
GO

/* Functional group: 08_INTERVIEW; referenced grouped tables: Numbers, tbl_recruitPostActiveInactivStatus, tbl_Tracker_InterviewTaken_Details, trecruitappliedpost, trecruitdepartment, trecruitpostlocation */
/****** Object:  StoredProcedure [dbo].[Proc_RecruitmentTracker]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Proc_RecruitmentTracker]          
@years VARCHAR(MAX),              
    @Month INT = NULL,              
    @selectWeek INT = NULL,                                    
    @DeptId VARCHAR(MAX) = NULL,                                    
    @PostId VARCHAR(MAX) = NULL,                                    
    @LocationId VARCHAR(MAX) = NULL,                  
    @postStatus INT = NULL              
AS          
BEGIN          
DECLARE @SearchYear INT = CAST(@years AS INT); -- Set the year          
DECLARE @CurrentMonth INT ;          
DECLARE @TOMonth INT     
DECLARE @Today DATE=GETDATE()    
IF @Month IS NOT NULL  BEGIN     SET @CurrentMonth = @Month;      SET @TOMonth = @Month; END ELSE  BEGIN     SET @CurrentMonth = 1;      SET @TOMonth = 12; END          
-- Temporary table to store results          
IF OBJECT_ID('tempdb..#FinalResults') IS NOT NULL          
    DROP TABLE #FinalResults;          
          
CREATE TABLE #FinalResults (          
    ActiveYear INT,          
    ActiveMonth INT,          
    MonthYear NVARCHAR(10), -- Added Month-Year column          
    WeekNum INT,          
    WeekStart DATE,          
    WeekEnd DATE,          
    plmapid INT,          
 postid Int,        
    DeptId INT,          
    locid INT,          
    postname NVARCHAR(255), -- Added postname column          
    Activeflag VARCHAR(10),          
    ActiveInactiveDate DATE          
);          
          
-- Loop through each month          
WHILE @CurrentMonth <= @TOMonth          
BEGIN          
    WITH WeekNumbers AS (          
        -- Generate week numbers for the selected month dynamically          
        SELECT           
            @SearchYear AS ActiveYear,          
            @CurrentMonth AS ActiveMonth,          
            FORMAT(DATEFROMPARTS(@SearchYear, @CurrentMonth, 1), 'MMM-yyyy') AS MonthYear, -- Generate Month-Year format          
            ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS WeekNum,          
            DATEADD(DAY, (ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1) * 7, DATEFROMPARTS(@SearchYear, @CurrentMonth, 1)) AS WeekStart          
        FROM master.dbo.spt_values           
        WHERE type = 'P' AND number BETWEEN 1 AND 6 -- Generates up to 6 weeks          
    )          
    SELECT           
        W.ActiveYear,           
        W.ActiveMonth,           
        W.MonthYear, -- Added formatted Month-Year column          
        W.WeekNum,           
        W.WeekStart,          
        CASE           
            WHEN DATEADD(DAY, 6, W.WeekStart) > EOMONTH(W.WeekStart)           
            THEN EOMONTH(W.WeekStart) -- Stop at the last day of the month          
            ELSE DATEADD(DAY, 6, W.WeekStart)          
        END AS WeekEnd          
    INTO #WeekData          
    FROM WeekNumbers W          
    WHERE W.WeekStart <= EOMONTH(DATEFROMPARTS(@SearchYear, @CurrentMonth, 1)) -- Ensure correct week count          
      AND (@SearchYear < YEAR(@Today) OR W.WeekStart <= @Today);    
    WITH PostStatus AS (          
        -- Get all post status changes, including postname          
        SELECT           
            a.plmapid,        
   a.postid,        
            a.DeptId,           
            a.locid,           
            a.postname, -- Added postname column          
            b.ActiveInactiveDate,           
            b.Activeflag,           
            YEAR(b.ActiveInactiveDate) AS ActiveYear,           
            MONTH(b.ActiveInactiveDate) AS ActiveMonth          
        FROM vw_Recruitment_AllPost a           
        INNER JOIN tbl_recruitPostActiveInactivStatus b           
            ON b.plmapid = a.plmapid          
    ),          
    WeeklyPostStatus AS (          
        -- Match every post to each week and get the latest status up to that week          
        SELECT           
            W.ActiveYear, W.ActiveMonth, W.MonthYear, W.WeekNum, W.WeekStart, W.WeekEnd,          
            P.plmapid,P.postid, P.DeptId, P.locid, P.postname, P.Activeflag, P.ActiveInactiveDate,          
            ROW_NUMBER() OVER (PARTITION BY P.plmapid, W.WeekNum ORDER BY P.ActiveInactiveDate DESC) AS LatestStatus          
        FROM #WeekData W          
        LEFT JOIN PostStatus P          
            ON P.ActiveInactiveDate <= W.WeekEnd -- Get the latest status up to that week          
    ),          
    FilledWeeks AS (          
        -- Ensure only the latest status for each post per week          
        SELECT           
            ActiveYear, ActiveMonth, MonthYear, WeekNum, WeekStart, WeekEnd,          
            plmapid,postid, DeptId, locid, postname, Activeflag,           
   FORMAT(ActiveInactiveDate, 'yyyy-MM-dd') AS ActiveInactiveDate          
        FROM WeeklyPostStatus          
        WHERE LatestStatus = 1 -- Only keep the most recent status for the week          
    ),          
    FinalStatus AS (          
        -- Carry forward missing statuses to ensure continuity          
        SELECT           
            FW.ActiveYear,           
            FW.ActiveMonth,           
            FW.MonthYear,           
            FW.WeekNum,           
            FW.WeekStart,           
            FW.WeekEnd,          
            FW.plmapid,          
   FW.postid,        
            FW.DeptId,           
            FW.locid,           
            FW.postname,           
            COALESCE(FW.Activeflag,           
                     LAG(FW.Activeflag) OVER (PARTITION BY FW.plmapid ORDER BY FW.WeekNum)) AS Activeflag,          
            COALESCE(FW.ActiveInactiveDate,           
                     LAG(FW.ActiveInactiveDate) OVER (PARTITION BY FW.plmapid ORDER BY FW.WeekNum)) AS ActiveInactiveDate          
        FROM FilledWeeks FW          
    )          
    -- Insert monthly data into the temporary table          
    INSERT INTO #FinalResults          
    SELECT           
        ActiveYear, ActiveMonth, MonthYear, WeekNum, WeekStart, WeekEnd,           
        plmapid,postid, DeptId, locid, postname, Activeflag, ActiveInactiveDate          
    FROM FinalStatus;          
          
    -- Move to the next month          
    SET @CurrentMonth = @CurrentMonth + 1;          
          
    -- Drop temporary table after each loop          
    DROP TABLE IF EXISTS #WeekData;          
END          
 --Select * from  #FinalResults         
        
-- Final Output          
SELECT A.plmapid,A.postid, A.MonthYear, A.ActiveMonth, A.WeekNum, B.Deptname, A.postname,          
C.location,FORMAT( A.ActiveInactiveDate, 'dd-MM-yyyy') AS Createdtime,          
(SELECT STUFF((SELECT DISTINCT ', ' + UPPER(candi.CandidatesName)                                
               FROM tbl_Tracker_InterviewTaken_Details candi                                
               WHERE candi.Plmapid = A.plmapid               
                 AND candi.InterviewYearMonth = A.MonthYear COLLATE SQL_Latin1_General_CP1_CI_AS          
                 AND candi.InterviewWeekNumber = A.WeekNum                               
               FOR XML PATH('')), 1, 2, '')) AS CandidatesName,                                
(SELECT STUFF((SELECT DISTINCT ', ' + emp.empfirstname + ' ' + emp.empmiddlename + ' ' + emp.emplastname                                
               FROM tbl_Tracker_InterviewTaken_Details candi                                
               INNER JOIN essp.dbo.Empbasic emp         
                   ON emp.empno = candi.InterviewTakenId                                
               WHERE candi.Plmapid = A.plmapid               
                 AND candi.InterviewYearMonth = A.MonthYear COLLATE SQL_Latin1_General_CP1_CI_AS          
                 AND candi.InterviewWeekNumber = A.WeekNum                            
               FOR XML PATH('')), 1, 2, '')) AS InterviewerName,                    
D.CandidatesPsychometryReport,                                    
D.CandidateBackgroundVerificationReport,                                    
D.ChallengesName,                                    
D.Remarks,                  
D.CandidateStatus,          
CASE         
    WHEN A.Activeflag = 'Y' THEN 1           
    WHEN A.Activeflag = 'N' THEN 0         
END AS Status          
FROM #FinalResults A          
        
INNER JOIN trecruitdepartment B         
    ON B.id = A.DeptId -- Removed COLLATE from INT column comparison          
INNER JOIN trecruitpostlocation C         
    ON C.locid = A.locid -- Removed COLLATE from INT column comparison          
LEFT JOIN tbl_Tracker_InterviewTaken_Details D                     
    ON A.plmapid = D.Plmapid               
   AND D.InterviewYearMonth = A.MonthYear COLLATE SQL_Latin1_General_CP1_CI_AS               
   AND D.InterviewWeekNumber = A.WeekNum         
           
WHERE (@selectWeek IS NULL OR A.WeekNum=@selectWeek)           
    and (@DeptId IS NULL OR A.DeptId IN (SELECT CAST(Name AS INT) AS DeptId FROM dbo.splitstring(@DeptId) ))          
 AND (@PostId IS NULL OR A.postid IN (Select CAST(postid AS INT)AS PostId from trecruitappliedpost where ActualPostID IN (SELECT CAST(Name AS INT) FROM dbo.splitstring(@PostId)) ))            
 AND (@LocationId IS NULL OR A.locid IN (SELECT CAST(Name AS INT) AS LocationId FROM dbo.splitstring(@LocationId)))      
 And(@postStatus IS NULL OR A.Activeflag=CASE         
    WHEN @postStatus = 1 THEN 'Y'           
    WHEN @postStatus = 0 THEN 'N'         
END)    
 --AND (@postStatus IS NULL OR A.Activeflag IN (SELECT CAST(Name AS INT) AS LocationId FROM dbo.splitstring(@postStatus)))    
GROUP BY          
    A.plmapid,A.postid, A.MonthYear, A.ActiveMonth, A.WeekNum, B.Deptname, A.postname,          
    C.location, A.ActiveInactiveDate,         
    D.CandidatesPsychometryReport,                                    
    D.CandidateBackgroundVerificationReport,                                    
    D.ChallengesName,                                    
    D.Remarks,                                    
    D.CandidateStatus,        
    A.Activeflag        
              
--ActiveMonth = 6 -- Uncomment to filter by month          
 ORDER BY  A.ActiveMonth desc, A.WeekNum desc, plmapid desc;          
-- Clean up          
DROP TABLE #FinalResults;          
END          
GO

/* Functional group: 08_INTERVIEW; referenced grouped tables: trecruitcanbasicdtls, trecruitcandidatesignup, trecruitinterviewdetails, trecruitinterviewrounddetails, trecruitinterviewroundssummary */
/****** Object:  StoredProcedure [dbo].[procinsertinterviewdtls]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Script for SelectTopNRows command from SSMS  ******/ 
CREATE PROCEDURE [dbo].[procinsertinterviewdtls] @postname        VARCHAR(300), 
                                                @cusername       VARCHAR(300), 
                                                @interviewstatus VARCHAR(10), 
                                                @username        VARCHAR(300), 
                                                @finterviewerid  VARCHAR(300), 
                                                @sinterviewerid  VARCHAR(300), 
                                                @interviewtime   VARCHAR(300), 
                                                @interviewdate   DATETIME, 
                                                @interviewmode   VARCHAR(10), 
                                                @intlocation     VARCHAR(1000), 
                                                @interviewround  VARCHAR(1000) 
AS 
  BEGIN 
      DECLARE @icndidatename VARCHAR(300) 
      DECLARE @postid INT 
      DECLARE @candidateid INT 
      DECLARE @locid INT 

      SELECT @candidateid = candidateid 
      FROM   [dbo].[trecruitcandidatesignup] 
      WHERE  username = @cusername 

      SELECT @postid = po.postid, 
             @locid = locid, 
             @candidateid = bac.candidateid, 
             @icndidatename = bac.candidatename 
      FROM   [vw_apppost] po, 
             [trecruitcandidatesignup]cu, 
             (SELECT bac.candidateid, 
                     bac.firstname + ' ' + bac.middlename + ' ' 
                     + bac.lastname candidatename 
              FROM   [dbo].[trecruitcanbasicdtls] bac 
              WHERE  bac.[applicationstatus] IN ( 'NEW' )) bac 
      WHERE  po.username = @cusername 
             AND po.postname = @postname 
             AND po.username = cu.username 
             AND bac.candidateid = cu.candidateid 

      INSERT INTO [dbo].[trecruitinterviewdetails] 
                  ([postid], 
                   postname, 
                   [locid], 
                   [candidateid], 
                   candidatename, 
                   [interviewstatus], 
                   [isactive], 
                   [createdby], 
                   [createddate], 
                   [modifiedby], 
                   [modifieddate]) 
      VALUES      (@postid, 
                   @postname, 
                   @locid, 
                   @candidateid, 
                   @icndidatename, 
                   @interviewstatus, 
                   1, 
                   @username, 
                   Getdate(), 
                   @username, 
                   Getdate()) 

      INSERT INTO [trecruitinterviewrounddetails] 
                  ([interviewid], 
                   [postid], 
                   [postname], 
                   [locid], 
                   [candidateid], 
                   [candidatename], 
                   [finterviewerid], 
                   [sinterviewerid], 
                   [interviewtime], 
                   [interviewdate], 
                   [interviewmode], 
                   [interviewroundnumber], 
                   [interviewround], 
                   [intlocation], 
                   [isactive], 
                   [createdby], 
                   [createddate], 
                   [modifiedby], 
                   [modifieddate]) 
      VALUES      ( @candidateid, 
                    @postid, 
                    @postname, 
                    @locid, 
                    @candidateid, 
                    @icndidatename, 
                    @finterviewerid, 
                    @sinterviewerid, 
                    @interviewtime, 
                    @interviewdate, 
                    @interviewmode, 
                    1, 
                    @interviewround, 
                    @intlocation, 
                    1, 
                    @username, 
                    Getdate(), 
                    @username, 
                    Getdate() ) 

      INSERT INTO [dbo].[trecruitinterviewroundssummary] 
                  ([postid], 
                   [postname], 
                   [locid], 
                   [candidateid], 
                   [candidatename], 
                   [candidatestatus], 
                   [interviewstatus], 
                   [interviewid], 
                   [finterviewerid], 
                   [sinterviewerid], 
                   [interviewtime], 
                   [interviewdate], 
                   [interviewmode], 
                   [interviewroundnumber], 
                   [interviewroundname], 
                   [location], 
                   [createdby], 
                   [modifiedby], 
                   [createddate], 
                   [modifieddate], 
                   [isactive]) 
      VALUES      ( @postid, 
                    @postname, 
                    @locid, 
                    @candidateid, 
                    @icndidatename, 
                    7, 
                    1, 
                    @candidateid, 
                    @finterviewerid, 
                    @sinterviewerid, 
                    @interviewtime, 
                    @interviewdate, 
                    @interviewmode, 
                    1, 
                    @interviewround, 
                    @intlocation, 
                    @username, 
                    @username, 
                    Getdate(), 
                    Getdate(), 
                    1 ) 
  END 
GO

/* Functional group: 08_INTERVIEW; referenced grouped tables: none detected */
/****** Object:  StoredProcedure [dbo].[procinterviewername]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Script for SelectTopNRows command from SSMS  ******/

CREATE procedure [dbo].[procinterviewername]
@interviewername varchar(200)
as
begin
SELECT [empName],[empcode] FROM [essp].[dbo].[emp]
where [empName] like @interviewername+'%'
and [STATUS]='ACTIVE'

end
GO

/* Functional group: 08_INTERVIEW; referenced grouped tables: none detected */
/****** Object:  StoredProcedure [dbo].[roundfouronlinecvstatus]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[roundfouronlinecvstatus]
as
begin
SELECT  [rfourcvnotreview]
      ,[rfourcvselectd]
      ,[rfourcvnotselect]
      ,[rfourcvonhold]
  FROM [dbo].[vw_roundfouronlinecvstatus]

end
GO

/* Functional group: 08_INTERVIEW; referenced grouped tables: none detected */
/****** Object:  StoredProcedure [dbo].[roundoneonlinecvstatus]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[roundoneonlinecvstatus]
as
begin
SELECT  [ronecvnotreview]
      ,[ronecvselectd]
      ,[ronecvnotselect]
      ,[ronecvonhold]
  FROM [dbo].[vw_roundoneonlinecvstatus]

end
GO

/* Functional group: 08_INTERVIEW; referenced grouped tables: none detected */
/****** Object:  StoredProcedure [dbo].[roundthreeonlinecvstatus]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[roundthreeonlinecvstatus]
as
begin
SELECT  [rthreecvnotreview]
      ,[rthreecvselectd]
      ,[rthreecvnotselect]
      ,[rthreecvonhold]
  FROM [dbo].[vw_roundthreeonlinecvstatus]

end
GO

/* Functional group: 08_INTERVIEW; referenced grouped tables: none detected */
/****** Object:  StoredProcedure [dbo].[roundtwoonlinecvstatus]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[roundtwoonlinecvstatus]
as
begin
SELECT [rtwocvnotreview]
      ,[rtwocvselectd]
      ,[rtwocvnotselect]
      ,[rtwocvonhold]
  FROM [dbo].[vw_roundtwoonlinecvstatus]

end
GO

/* Functional group: 08_INTERVIEW; referenced grouped tables: Tbl_Interview_Taken_Details, trecruitcanbasicdtls */
/****** Object:  StoredProcedure [dbo].[Sp_GetInterviewerDtls_Feedback]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[Sp_GetInterviewerDtls_Feedback]        
@Id int=null,      
@Cand_Regno varchar(max),        
@Action varchar(max),        
@InterviewTaken_DeptID int=null,        
@InterviewTaken_PersonID int =null,        
@InterviewRound int =null,        
@Interview_Remarks varchar(max)=null        
as              
begin              
              
    DECLARE @candidateid INT;              
 SELECT @candidateid = candidateid                       
    FROM trecruitcanbasicdtls                       
    WHERE registrationnumber = @Cand_Regno;             
         
        
       IF @candidateid IS NULL        
    BEGIN        
        PRINT 'Candidate not found.';        
        RETURN;        
    END        
        
        
       IF @Action = 'Select'        
    BEGIN        
               
 SELECT      
 intdtls.Id,    
    intdtls.Cand_regno,              
    CndDtls.firstname + ' ' + ISNULL(CndDtls.middlename + ' ', '') + CndDtls.lastname AS CandidateFullName,            
    emp1.empfirstname + ' ' + ISNULL(emp1.empmiddlename + ' ', '') + emp1.emplastname   AS InterviewerName ,            
 dept1.Department as InterviewerDept,            
 intdtls.InterviewRound,          
 intdtls.Interview_Remarks 
             
    --'[ ' + emp1.empfirstname + ' ' + ISNULL(emp1.empmiddlename + ' ', '') + emp1.emplastname + ' - ' + dept1.Department + ' ]' AS R1_interviewerNameDept,              
    --'[ ' + emp2.empfirstname + ' ' + ISNULL(emp2.empmiddlename + ' ', '') + emp2.emplastname + ' - ' + dept2.Department + ' ]' AS R2_interviewerNameDept,              
    --'[ ' + emp3.empfirstname + ' ' + ISNULL(emp3.empmiddlename + ' ', '') + emp3.emplastname + ' - ' + dept3.Department + ' ]' AS R3_interviewerNameDept,              
    --'[ ' + emp4.empfirstname + ' ' + ISNULL(emp4.empmiddlename + ' ', '') + emp4.emplastname + ' - ' + dept4.Department + ' ]' AS R4_interviewerNameDept              
FROM               
    Tbl_Interview_Taken_Details AS intdtls              
LEFT JOIN               
    abcinfotechpvtltdESSP.dbo.Empbasic AS emp1 ON intdtls.InterviewTaken_PersonID = emp1.empid              
LEFT JOIN               
    abcinfotechpvtltdESSP.dbo.Department AS dept1 ON intdtls.InterviewTaken_DeptID = dept1.DepartmentId              
--LEFT JOIN               
--    abcinfotechpvtltdESSP.dbo.Empbasic AS emp2 ON intdtls.R2_Interview_Taken_Person_id = emp2.empid              
--LEFT JOIN               
--    abcinfotechpvtltdESSP.dbo.Department AS dept2 ON intdtls.R2_Interview_Taken_Dept_Id = dept2.DepartmentId              
--LEFT JOIN               
--    abcinfotechpvtltdESSP.dbo.Empbasic AS emp3 ON intdtls.R3_Interview_Taken_Person_id = emp3.empid              
--LEFT JOIN               
--    abcinfotechpvtltdESSP.dbo.Department AS dept3 ON intdtls.R3_Interview_Taken_Dept_Id = dept3.DepartmentId              
--LEFT JOIN               
--    abcinfotechpvtltdESSP.dbo.Empbasic AS emp4 ON intdtls.R4_Interview_Taken_Person_id = emp4.empid              
--LEFT JOIN               
--    abcinfotechpvtltdESSP.dbo.Department AS dept4 ON intdtls.R4_Interview_Taken_Dept_Id = dept4.DepartmentId              
INNER JOIN               
    vw_rcalldata AS a ON a.registrationnumber = intdtls.Cand_regno              
INNER JOIN               
    trecruitcanbasicdtls AS CndDtls ON intdtls.Cand_regno = CndDtls.registrationnumber              
 WHERE intdtls.Cand_regno = @Cand_Regno;         
         
END        
    IF @Action = 'Update'        
    BEGIN        
        PRINT 'Updating record for Cand_Regno: ' + @Cand_Regno + ' and Id: ' + CAST(@Id AS VARCHAR);  -- Debugging line    
            
        UPDATE Tbl_Interview_Taken_Details        
        SET     
            InterviewTaken_DeptID = @InterviewTaken_DeptID,        
            InterviewTaken_PersonID = @InterviewTaken_PersonID,        
            Interview_Remarks = @Interview_Remarks,        
            InterviewRound = @InterviewRound        
        WHERE     
            Cand_Regno = @Cand_Regno AND Id = @Id;        
    
        -- Check if update was successful    
        IF @@ROWCOUNT = 0    
        BEGIN    
            PRINT 'No record found to update.';    
        END    
      ELSE    
        BEGIN    
            PRINT 'Update successful.';    
        END    
    END               
        
        
end
GO

/* Functional group: 08_INTERVIEW; referenced grouped tables: Tbl_Interview_Taken_Details, trecruitcanbasicdtls */
/****** Object:  StoredProcedure [dbo].[Sp_GetRecruitmentRecordTrackerOnProcess]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Sp_GetRecruitmentRecordTrackerOnProcess]        
@Cand_Regno VARCHAR(MAX)=null ,  
@CanBackgroundVerification varchar(max)=null,  
@CanSelectionStatus varchar(max)=null,  
@Action varchar(20) =null  
as        
begin        
        
    
 if @Cand_Regno is null    
 begin    
SELECT   
    TOP 3
    rqt.registrationnumber,        
    rqt.aplicationdate,        
     CAST(YEAR(convert( Datetime,rqt.aplicationdate,103)) AS VARCHAR(4)) + '-' + LEFT(DATENAME(MONTH, convert( Datetime,rqt.aplicationdate,103)), 3) AS YearMonth,        
    ((DAY(convert( Datetime,rqt.aplicationdate,103)) - 1) / 7) + 1 AS WeekNumber,        
    rqt.candidateid,        
    rqt.CandidateName,        
    rqt.postname,        
    rqt.postid,        
    rqt.deptdivision,        
    rqt.location,        
    rqt.locid,        
    rqt.deptname,        
    STRING_AGG('[ ' + emp.empfirstname + ' ' + ISNULL(emp.empmiddlename + ' ', '') + emp.emplastname + ' - ' + dept.Department + ' ]', ', ') AS InterviewerName_Dept  ,  
 canbasic.CanBackgroundVerification,  
 canbasic.CanSelectionStatus  
FROM         
    [vw_recruittracker] AS rqt        
LEFT JOIN         
    Tbl_Interview_Taken_Details AS intdtls ON intdtls.Cand_Regno = rqt.registrationnumber        
LEFT JOIN         
    abcinfotechpvtltdESSP.dbo.Empbasic AS emp ON intdtls.InterviewTaken_PersonID = emp.empid        
LEFT JOIN         
    abcinfotechpvtltdESSP.dbo.Department AS dept ON intdtls.InterviewTaken_DeptID = dept.DepartmentId    
left join trecruitcanbasicdtls as canbasic on rqt.registrationnumber=canbasic.registrationnumber  
 --where rqt.registrationnumber='Candidate004559'      
GROUP BY         
    rqt.registrationnumber,        
    rqt.aplicationdate,        
    rqt.candidateid,        
    rqt.CandidateName,        
    rqt.postname,        
    rqt.postid,        
    rqt.deptdivision,        
    rqt.location,        
    rqt.locid,        
    rqt.deptname,  
 canbasic.CanBackgroundVerification,  
 canbasic.CanSelectionStatus;  
   
    end    
 else if @Cand_Regno is not null    
 begin    
 select registrationnumber,candidateid,CandidateName,postname,deptname,deptdivision from [vw_recruittracker]    
 where registrationnumber=@Cand_Regno    
 end    
      
   
  
 if @Action='Update'  
 begin  
 update trecruitcanbasicdtls  
 set CanSelectionStatus=@CanSelectionStatus,  
  CanBackgroundVerification=@CanBackgroundVerification  
 where registrationnumber=@Cand_Regno  
 end  
    
  
end 
GO

/* Functional group: 08_INTERVIEW; referenced grouped tables: Tbl_Interview_Taken_Details */
/****** Object:  StoredProcedure [dbo].[Sp_GetSelectedDepartmentById]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Sp_GetSelectedDepartmentById]         
    @id int = NULL         
    --@Action VARCHAR(20)          
AS          
BEGIN       
    
        SELECT distinct          
            dept.Department ,         
            dept.DepartmentId    
       
            --emp.empfirstname + ' ' + ISNULL(emp.empmiddlename + ' ', '') + emp.emplastname AS EmployeeName,          
            --emp.empid          
        FROM Tbl_Interview_Taken_Details as Intdtl    
  inner join abcinfotechpvtltdESSP.dbo.Department as dept    
  on dept.DepartmentId =Intdtl.InterviewTaken_DeptID   
  where Intdtl.id=@id    
      
    
  --select * from abcinfotechpvtltdESSP.dbo.Department    
   --         abcinfotechpvtltdESSP.dbo.Department AS dpt          
   --     left JOIN           
   --         abcinfotechpvtltdESSP.dbo.Empbasic AS emp     
   --left join Tbl_Interview_Taken_Details as Intdtl    
   --     ON           
   --         dpt.DepartmentId = emp.empdept      
   --on Intdtl.InterviewTaken_DeptID=dpt.DepartmentId    
    
   --     WHERE           
   --         emp.empstatus = 'ACTIVE' and Intdtl.InterviewTaken_DeptID=@id;          
    
end
GO

/* Functional group: 08_INTERVIEW; referenced grouped tables: Tbl_Interview_Taken_Details, trecruitcanbasicdtls */
/****** Object:  StoredProcedure [dbo].[Sp_Save_Interview_Taken_dtls]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Sp_Save_Interview_Taken_dtls]          
    @Cand_Regno VARCHAR(MAX),          
    @InterviewTaken_DeptID INT=null,          
    @InterviewTaken_PersonID INT=null,          
    @Interview_Remarks VARCHAR(MAX)=null,  
 @InterviewRound int =null  
    
  --@R2_Interview_Taken_Dept_Id INT=null,          
  --  @R2_Interview_Taken_Person_id INT=null,          
  --  @R2_Interview_Remarks VARCHAR(MAX)=null,    
    
  --@R3_Interview_Taken_Dept_Id INT=null,          
  --  @R3_Interview_Taken_Person_id INT=null,          
  --  @R3_Interview_Remarks VARCHAR(MAX)=null,    
    
  --@R4_Interview_Taken_Dept_Id INT=null,          
  --  @R4_Interview_Taken_Person_id INT=null,          
  --  @R4_Interview_Remarks VARCHAR(MAX)=null    
AS          
BEGIN          
    DECLARE @candidateid INT;          
        
    SELECT @candidateid = candidateid           
    FROM trecruitcanbasicdtls           
    WHERE registrationnumber = @Cand_Regno;          
        
        
 --select * from trecruitcanbasicdtls where registrationnumber='Candidate004558'        
        
    INSERT INTO Tbl_Interview_Taken_Details           
        (Cand_Regno, candidateid, InterviewTaken_DeptID, InterviewTaken_PersonID, Interview_Remarks, InterviewRound   
  --R2_Interview_Taken_Dept_Id,R2_Interview_Taken_Person_id,R2_Interview_Remarks,    
  --R3_Interview_Taken_Dept_Id,R3_Interview_Taken_Person_id,R3_Interview_Remarks ,    
  --R4_Interview_Taken_Dept_Id,R4_Interview_Taken_Person_id,R4_Interview_Remarks    
  )           
    VALUES           
        (@Cand_Regno, @candidateid, @InterviewTaken_DeptID, @InterviewTaken_PersonID, @Interview_Remarks, @InterviewRound   
  --@R2_Interview_Taken_Dept_Id,@R2_Interview_Taken_Person_id,@R2_Interview_Remarks,    
  --@R3_Interview_Taken_Dept_Id,@R3_Interview_Taken_Person_id,@R3_Interview_Remarks,    
  --@R4_Interview_Taken_Dept_Id,@R4_Interview_Taken_Person_id,@R4_Interview_Remarks    
  );          
        
    PRINT 'Interview details saved successfully.';        
END;
GO



/* ---- TEMP / DEMO / SAMPLE / TEST / BACKUP PROCEDURES ---- */

/* Functional group: 08_INTERVIEW; referenced grouped tables: tbl_RecruiterInterviewersSchedule, trecruitpostlocationmap */
/****** Object:  StoredProcedure [dbo].[PorcCustomerstestList_NEW_temp]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[PorcCustomerstestList_NEW_temp]                                           
--@PageNo   Bigint ,                                  
--@SearchValue Varchar(100),                                  
--@ColumnName  Varchar(100),        
@canname Varchar(max),        
@deptname Varchar(max),        
@postname Varchar(max),        
@startdate varchar(50),                            
@enddate varchar(50)                            
As                                                
Begin                                                
                                        
Declare @RowsInPage Bigint=10                                        
Declare @TotalRows Bigint=0                                           
Declare @TotalPage Bigint=0                                          
Declare @StartNo Bigint=0                                           
--Declare @TB Table                                   
--(                                  
--SRL   Bigint,                                  
--registrationnumber varchar(100),                              
--backgroundcheck varchar(10),                               
--aplicationdate varchar(30),                               
--username varchar(100),                              
--rscandidateid int,                               
--rscandidatename Varchar(100),                              
--resumefile varbinary(max),                               
--applicationstatus varchar(50),                               
--rspostname varchar(600),                               
--rspostid int,                              
--rslocid bigint,                              
--location varchar(100),                               
--deptname varchar(300),                               
--deptdivision varchar(402),                               
--referredus varchar(500),                        
--ReferredOthertext varchar(600),                        
--trakerid bigint,                               
--referenceno varchar(50),                               
--departmentdivision varchar(50),                               
--departmentdivisonname varchar(50),                              
--rtpostid int,                               
--rtpostname varchar(300),                              
--rtlocid int,                               
--headq varchar(300),                              
--rtcandidateid int,                               
--rtcandidatename varchar(300),                               
--source varchar(500),                               
--STARTDATE varchar(20),                               
--cvselected varchar(50),                               
--manualupdate varchar(50),                               
--roneinterviewdate varchar(20),                               
--roneinterviewernameone varchar(500),                              
--roneinterviewernametwo varchar(500),                              
--roneselect varchar(10),                          
--roneinterviewenddate varchar(20),                          
--rtwointerviewdate varchar(50),                               
--rtwointerviewernameone varchar(500),                               
--rtwointerviewernametwo varchar(500),                              
--rtwoselect varchar(10),                            
--rtwointerviewenddate varchar(50),                            
--rthreeinterviewdate varchar(50),                              
--rthreeinterviewernameone varchar(500),                              
--rthreeinterviewernametwo varchar(500),                               
--rthreeselect varchar(10),                          
--rthreeinterviewenddate varchar(50),                          
--frinterviewdate varchar(50),                              
--frinterviewernameone varchar(500),                               
--frinterviewernametwo varchar(500),                              
--frselect varchar(10),                            
--Frinterviewenddate varchar(50),                          
--doo varchar(50),                              
--doj varchar(50),     
--empcode varchar(100),                               
--completionstatus varchar(50),                              
--timetaken varchar(50),                             
--remarks varchar(500),                   
--createdby varchar(500),                               
--modifiedby varchar(500),                              
----modifiedtime datetime,                   
--rofileid bigint,                              
--rocandidateid int,                               
--rofname varchar(50),                              
--rofcontenttype varchar(200),                               
--rofresumefile varchar(max),                              
--ronerone varchar(5),                               
--rosname varchar(50),                              
--roscontenttype varchar(200),                               
--rosresumefile varchar(max),                              
--ronertwo varchar(5),                               
--rtwfileid bigint ,                              
--rtwcandidateid int,                               
--rtwfname varchar(50),                              
--rtwfcontenttype nvarchar(200),                              
--rtwfresumefile varchar(max),                               
--rtworone varchar(5),                              
--rtwsname varchar(50),                               
--rtwscontenttype varchar(200),                              
--rtwsresumefile varchar(max),                              
--rtwortwo varchar(5),                              
--rthfileid bigint,                               
--rthcandidateid int,                               
--rthfname varchar(50),                              
--rthfcontenttype varchar(200),                               
--rthfresumefile varchar(max),                              
--rthworone varchar(5),                              
--rthsname varchar(50),                              
--rthscontenttype nvarchar(200),                               
--rthsresumefile varchar(max),                              
--rthwortwo varchar(5),                               
--fileid bigint,                              
--rfcandidateid int,                              
--fname varchar(50),                              
--fcontenttype nvarchar(200),                               
--fresumefile varchar(max),                               
--rfworone varchar(5),                              
--sname varchar(50),                               
--scontenttype nvarchar(200),                               
--sresumefile varchar(max),                              
--rfwortwo varchar(5),                               
----createdtime datetime,                              
--docsubmissionallow varchar(10)                              
                              
--)                                  
                                  
--if (@canname !='' OR @deptname !='' OR @postname !='')-- Search Call on List Page                                  
--Begin                                  
 --if (@ColumnName='RSCANDIDATENAME')                                  
 --Begin                                  
   --Insert into @TB                                  
   --(SRL,registrationnumber, [backgroundcheck],                               
   --[aplicationdate], [username],                               
   --[rscandidateid], [rscandidatename],                              
   --[resumefile], [applicationstatus],                               
   --[rspostname], [rspostid], [rslocid],                              
   --[location], [deptname], [deptdivision],                               
   --[referredus],[ReferredOthertext], [trakerid], [referenceno],                               
   --[departmentdivision], [departmentdivisonname],                              
   --[rtpostid], [rtpostname], [rtlocid], [headq],                              
   --[rtcandidateid], [rtcandidatename], [source],                               
   --[STARTDATE], [cvselected], [manualupdate],                               
   --[roneinterviewdate], [roneinterviewernameone],                              
   --[roneinterviewernametwo], [roneselect],[roneinterviewenddate],                               
   --[rtwointerviewdate], [rtwointerviewernameone],                               
   --[rtwointerviewernametwo], [rtwoselect],[rtwointerviewenddate],                               
   --[rthreeinterviewdate], [rthreeinterviewernameone],                              
   --[rthreeinterviewernametwo], [rthreeselect],[rthreeinterviewenddate],                              
   --[frinterviewdate], [frinterviewernameone],                               
   --[frinterviewernametwo], [frselect],[Frinterviewenddate], [doo], [doj],                              
   --[empcode], [completionstatus], [timetaken],                               
   --[remarks], [createdby], [modifiedby],                              
   ----[modifiedtime],                               
   --[rofileid], [rocandidateid],                               
   --[rofname], [rofcontenttype], [rofresumefile],                              
   --[ronerone], [rosname], [roscontenttype],                               
   --[rosresumefile], [ronertwo], [rtwfileid],                              
   --[rtwcandidateid], [rtwfname], [rtwfcontenttype],                              
   --[rtwfresumefile], [rtworone], [rtwsname],                               
   --[rtwscontenttype], [rtwsresumefile], [rtwortwo],                              
   --[rthfileid], [rthcandidateid], [rthfname],                              
   --[rthfcontenttype], [rthfresumefile], [rthworone],           
   --[rthsname], [rthscontenttype], [rthsresumefile],                              
   --[rthwortwo], [fileid], [rfcandidateid], [fname],                              
   --[fcontenttype], [fresumefile], [rfworone],                              
   --[sname], [scontenttype], [sresumefile],                              
   --[rfwortwo],                               
   ----[createdtime],                              
   --[docsubmissionallow]                              
   --)                              
                              
   SELECT ROW_NUMBER() OVER(ORDER BY A.registrationnumber desc)AS SRL,                                          
      A.registrationnumber,[backgroundcheck],   
	   CASE WHEN exists (Select InterviewersRoundNo from tbl_RecruiterInterviewersSchedule 
                          where CandidateRegistrationNumber=A.registrationnumber
                         and InterviewersRoundNo=1)THEN 1 ELSE 0 END AS InterviewerRound1,
        CASE WHEN exists (Select InterviewersRoundNo from tbl_RecruiterInterviewersSchedule 
                          where CandidateRegistrationNumber=A.registrationnumber
                         and InterviewersRoundNo=2)THEN 1 ELSE 0 END AS InterviewerRound2,
         CASE WHEN exists (Select InterviewersRoundNo from tbl_RecruiterInterviewersSchedule 
                          where CandidateRegistrationNumber=A.registrationnumber
                         and InterviewersRoundNo=3)THEN 1 ELSE 0 END AS InterviewerRound3,
		CASE WHEN exists (Select InterviewersRoundNo from tbl_RecruiterInterviewersSchedule 
                          where CandidateRegistrationNumber=A.registrationnumber
                         and InterviewersRoundNo=4)THEN 1 ELSE 0 END AS InterviewerRound4,
   A.[aplicationdate], A.[username],                      
   A.[rscandidateid], A.[rscandidatename] ,                              
   A.[resumefile], A.[applicationstatus],     
   CASE          WHEN A.[applicationstatus] = 'RESUBMIT' THEN 'No'         WHEN A.[applicationstatus] = 'SUBMITTED' THEN 'Yes'         ELSE NULL       END AS ResubmitStatus,    
   A.[rspostname], A.[rspostid], A.[rslocid],                              
   A.[location], A.[deptname], A.[deptdivision],                               
   upper (A.[referredus])referredus,Upper(A.[ReferredOthertext])ReferredOthertext, A.[trakerid], A.[referenceno],                   
   A.[departmentdivision], A.[departmentdivisonname],                              
   A.[rtpostid], A.[rtpostname], A.[rtlocid], A.[headq],                              
   A.[rtcandidateid], A.[rtcandidatename], A.[source],                               
   A.[STARTDATE], A.[cvselected], A.[manualupdate],                               
   A.[roneinterviewdate], A.[roneinterviewernameone],                              
A.[roneinterviewernametwo], A.[roneselect], A.[roneinterviewenddate],                               
   A.[rtwointerviewdate], A.[rtwointerviewernameone],                               
   A.[rtwointerviewernametwo], A.[rtwoselect], A.[rtwointerviewenddate],                               
   A.[rthreeinterviewdate], A.[rthreeinterviewernameone],                              
   A.[rthreeinterviewernametwo], A.[rthreeselect], A.[rthreeinterviewenddate],                                  
   A.[frinterviewdate], A.[frinterviewernameone],                               
   A.[frinterviewernametwo], A.[frselect],A.[Frinterviewenddate], A.[doo], A.[doj],                              
   A.[empcode], A.[completionstatus], A.[timetaken],                               
   A.[remarks], A.[createdby], A.[modifiedby],                              
   --A.[modifiedtime],                               
   A.[rofileid], A.[rocandidateid],                               
   A.[rofname], A.[rofcontenttype], A.[rofresumefile],                              
   A.[ronerone], A.[rosname], A.[roscontenttype],                               
   A.[rosresumefile], A.[ronertwo], A.[rtwfileid],                              
   A.[rtwcandidateid], A.[rtwfname], A.[rtwfcontenttype],                              
   A.[rtwfresumefile], A.[rtworone], A.[rtwsname],                               
   A.[rtwscontenttype], A.[rtwsresumefile], A.[rtwortwo],                              
   A.[rthfileid], A.[rthcandidateid], A.[rthfname],              
   A.[rthfcontenttype], A.[rthfresumefile], A.[rthworone],                              
   A.[rthsname], A.[rthscontenttype], A.[rthsresumefile],                              
   A.[rthwortwo], A.[fileid], A.[rfcandidateid], A.[fname],                              
   A.[fcontenttype], A.[fresumefile], A.[rfworone],                              
   A.[sname], A.[scontenttype], A.[sresumefile],                    
   A.[rfwortwo],                              
   --A.[createdtime],                              
   A.[docsubmissionallow]                                
   FROM vw_rcalldata A                    
   LEFT join trecruitpostlocationmap B on A.rspostid=B.postid and A.rslocid=B.locid                    
   Where  A.rscandidatename= Case When @canname= 'SELECT CANDIDATE NAME' Then A.rscandidatename Else @canname  End          
      AND A.deptdivision= Case When @deptname= 'SELECT DEPARTMENT' Then A.deptdivision Else @deptname  End         
   AND A.rspostname= Case When @postname= 'SELECT POST' Then A.rspostname Else @postname  End         
 AND  convert(datetime,(convert(varchar, convert(datetime, A.aplicationdate, 103), 101)),111)                            
   BETWEEN convert(datetime,(convert(varchar, convert(datetime, @startdate, 103), 101)),111) AND                             
   convert(datetime,(convert(varchar, convert(datetime, @enddate, 103), 101)),111)                   
 and A.rspostname not like 'ASSOCIATE%'              
 --END                         
                    
                    
--if (@ColumnName='RSPOSTNAME')                                  
-- Begin                 
--   Insert into @TB                                  
--   (SRL,registrationnumber, [backgroundcheck],                               
--   [aplicationdate], [username],                               
--   [rscandidateid], [rscandidatename],                              
--   [resumefile], [applicationstatus],                               
--   [rspostname], [rspostid], [rslocid],                              
--   [location], [deptname], [deptdivision],                               
--   [referredus],[ReferredOthertext], [trakerid], [referenceno],                               
--   [departmentdivision], [departmentdivisonname],                              
--   [rtpostid], [rtpostname], [rtlocid], [headq],                              
--   [rtcandidateid], [rtcandidatename], [source],                               
--   [STARTDATE], [cvselected], [manualupdate],                               
--   [roneinterviewdate], [roneinterviewernameone],                              
--   [roneinterviewernametwo], [roneselect],[roneinterviewenddate],                               
--   [rtwointerviewdate], [rtwointerviewernameone],                               
--   [rtwointerviewernametwo], [rtwoselect],[rtwointerviewenddate],                               
--   [rthreeinterviewdate], [rthreeinterviewernameone],                              
--   [rthreeinterviewernametwo], [rthreeselect],[rthreeinterviewenddate],                              
--   [frinterviewdate], [frinterviewernameone],                      
--   [frinterviewernametwo], [frselect],[Frinterviewenddate], [doo], [doj],                              
--   [empcode], [completionstatus], [timetaken],                               
--   [remarks], [createdby], [modifiedby],                              
--   --[modifiedtime],                               
--   [rofileid], [rocandidateid],                               
--   [rofname], [rofcontenttype], [rofresumefile],                              
--   [ronerone], [rosname], [roscontenttype],                 
--   [rosresumefile], [ronertwo], [rtwfileid],                              
--   [rtwcandidateid], [rtwfname], [rtwfcontenttype],                             
--   [rtwfresumefile], [rtworone], [rtwsname],                               
--   [rtwscontenttype], [rtwsresumefile], [rtwortwo],                              
--   [rthfileid], [rthcandidateid], [rthfname],                              
--   [rthfcontenttype], [rthfresumefile], [rthworone],                              
--   [rthsname], [rthscontenttype], [rthsresumefile],                        
--   [rthwortwo], [fileid], [rfcandidateid], [fname],                              
--   [fcontenttype], [fresumefile], [rfworone],                              
--   [sname], [scontenttype], [sresumefile],                              
--   [rfwortwo],                               
--   --[createdtime],                              
--   [docsubmissionallow]                              
--   )                              
                              
--   SELECT ROW_NUMBER() OVER(ORDER BY A.registrationnumber desc)AS SRL,                                          
--      A.registrationnumber,[backgroundcheck],                               
--   A.[aplicationdate], A.[username],                               
--   A.[rscandidateid], A.[rscandidatename] ,                              
--   A.[resumefile], A.[applicationstatus],                               
--   A.[rspostname], A.[rspostid], A.[rslocid],                              
--   A.[location], A.[deptname], A.[deptdivision],                               
--   A.[referredus],A.[ReferredOthertext], A.[trakerid], A.[referenceno],                               
--   A.[departmentdivision], A.[departmentdivisonname],                              
--   A.[rtpostid], A.[rtpostname], A.[rtlocid], A.[headq],                              
--   A.[rtcandidateid], A.[rtcandidatename], A.[source],                               
--   A.[STARTDATE], A.[cvselected], A.[manualupdate],                               
--   A.[roneinterviewdate], A.[roneinterviewernameone],                              
--   A.[roneinterviewernametwo], A.[roneselect], A.[roneinterviewenddate],                               
--   A.[rtwointerviewdate], A.[rtwointerviewernameone],                               
--   A.[rtwointerviewernametwo], A.[rtwoselect], A.[rtwointerviewenddate],                               
--   A.[rthreeinterviewdate], A.[rthreeinterviewernameone],                              
--   A.[rthreeinterviewernametwo], A.[rthreeselect], A.[rthreeinterviewenddate],                                  
--   A.[frinterviewdate], A.[frinterviewernameone],                               
--   A.[frinterviewernametwo], A.[frselect],A.[Frinterviewenddate], A.[doo], A.[doj],                              
--   A.[empcode], A.[completionstatus], A.[timetaken],                               
--   A.[remarks], A.[createdby], A.[modifiedby],                              
--   --A.[modifiedtime],                               
--   A.[rofileid], A.[rocandidateid],                               
--   A.[rofname], A.[rofcontenttype], A.[rofresumefile],                              
--   A.[ronerone], A.[rosname], A.[roscontenttype],                               
--   A.[rosresumefile], A.[ronertwo], A.[rtwfileid],                              
--   A.[rtwcandidateid], A.[rtwfname], A.[rtwfcontenttype],                              
--   A.[rtwfresumefile], A.[rtworone], A.[rtwsname],                               
--   A.[rtwscontenttype], A.[rtwsresumefile], A.[rtwortwo],                              
--   A.[rthfileid], A.[rthcandidateid], A.[rthfname],                              
--   A.[rthfcontenttype], A.[rthfresumefile], A.[rthworone],                              
--   A.[rthsname], A.[rthscontenttype], A.[rthsresumefile],                              
--   A.[rthwortwo], A.[fileid], A.[rfcandidateid], A.[fname],                              
--   A.[fcontenttype], A.[fresumefile], A.[rfworone],                              
--   A.[sname], A.[scontenttype], A.[sresumefile],                              
--   A.[rfwortwo],                              
--   --A.[createdtime],                              
--   A.[docsubmissionallow]                                
--   FROM vw_rcalldata A                         
--   LEFT join trecruitpostlocationmap B on A.rspostid=B.postid and A.rslocid=B.locid                    
--   Where  A.rspostname Like @SearchValue +'%'   AND                            
--   convert(datetime,(convert(varchar, convert(datetime, A.aplicationdate, 103), 101)),111)                            
--   BETWEEN convert(datetime,(convert(varchar, convert(datetime, @startdate, 103), 101)),111) AND                     
--   convert(datetime,(convert(varchar, convert(datetime, @enddate, 103), 101)),111)                   
--and A.rspostname not like 'ASSOCIATE%'                 
-- END                         
                    
--if (@ColumnName='RSDEPTNAME')                                  
-- Begin                                  
--   Insert into @TB                                  
--   (SRL,registrationnumber, [backgroundcheck],                               
--   [aplicationdate], [username],                               
--   [rscandidateid], [rscandidatename],                   
--   [resumefile], [applicationstatus],         
--   [rspostname], [rspostid], [rslocid],                              
--   [location], [deptname], [deptdivision],                               
--   [referredus],[ReferredOthertext], [trakerid], [referenceno],                               
--   [departmentdivision], [departmentdivisonname],                              
--   [rtpostid], [rtpostname], [rtlocid], [headq],                              
--   [rtcandidateid], [rtcandidatename], [source],                               
--   [STARTDATE], [cvselected], [manualupdate],                               
--   [roneinterviewdate], [roneinterviewernameone],                              
--   [roneinterviewernametwo], [roneselect],[roneinterviewenddate],                               
--   [rtwointerviewdate], [rtwointerviewernameone],                               
--   [rtwointerviewernametwo], [rtwoselect],[rtwointerviewenddate],                               
--   [rthreeinterviewdate], [rthreeinterviewernameone],                              
--   [rthreeinterviewernametwo], [rthreeselect],[rthreeinterviewenddate],                              
--   [frinterviewdate], [frinterviewernameone],                               
--   [frinterviewernametwo], [frselect],[Frinterviewenddate], [doo], [doj],                              
--   [empcode], [completionstatus], [timetaken],                               
--   [remarks], [createdby], [modifiedby],                              
--   --[modifiedtime],                               
--   [rofileid], [rocandidateid],                               
--   [rofname], [rofcontenttype], [rofresumefile],                              
--   [ronerone], [rosname], [roscontenttype],                               
--   [rosresumefile], [ronertwo], [rtwfileid],                              
--   [rtwcandidateid], [rtwfname], [rtwfcontenttype],                              
--   [rtwfresumefile], [rtworone], [rtwsname],                               
--   [rtwscontenttype], [rtwsresumefile], [rtwortwo],                              
--   [rthfileid], [rthcandidateid], [rthfname],                         
--   [rthfcontenttype], [rthfresumefile], [rthworone],                              
--   [rthsname], [rthscontenttype], [rthsresumefile],                              
--   [rthwortwo], [fileid], [rfcandidateid], [fname],                              
--   [fcontenttype], [fresumefile], [rfworone],                              
--   [sname], [scontenttype], [sresumefile],                              
--   [rfwortwo],                               
--   --[createdtime],                              
--   [docsubmissionallow]                              
--   )                              
                              
--   SELECT ROW_NUMBER() OVER(ORDER BY A.registrationnumber desc)AS SRL,                         
--      A.registrationnumber,[backgroundcheck],                               
--   A.[aplicationdate], A.[username],                               
--   A.[rscandidateid], A.[rscandidatename] ,                              
--   A.[resumefile], A.[applicationstatus],                               
--   A.[rspostname], A.[rspostid], A.[rslocid],                              
--   A.[location], A.[deptname], A.[deptdivision],                       
--   A.[referredus],A.[ReferredOthertext], A.[trakerid], A.[referenceno],                               
--   A.[departmentdivision], A.[departmentdivisonname],                              
--   A.[rtpostid], A.[rtpostname], A.[rtlocid], A.[headq],                              
--   A.[rtcandidateid], A.[rtcandidatename], A.[source],                               
--   A.[STARTDATE], A.[cvselected], A.[manualupdate],                               
--   A.[roneinterviewdate], A.[roneinterviewernameone],                              
--   A.[roneinterviewernametwo], A.[roneselect], A.[roneinterviewenddate],                               
--   A.[rtwointerviewdate], A.[rtwointerviewernameone],                               
--   A.[rtwointerviewernametwo], A.[rtwoselect], A.[rtwointerviewenddate],                               
--   A.[rthreeinterviewdate], A.[rthreeinterviewernameone],                              
--   A.[rthreeinterviewernametwo], A.[rthreeselect], A.[rthreeinterviewenddate],         
--   A.[frinterviewdate], A.[frinterviewernameone],                               
--   A.[frinterviewernametwo], A.[frselect],A.[Frinterviewenddate], A.[doo], A.[doj],                              
--   A.[empcode], A.[completionstatus], A.[timetaken],                               
--   A.[remarks], A.[createdby], A.[modifiedby],                              
--   --A.[modifiedtime],                               
--   A.[rofileid], A.[rocandidateid],                               
--   A.[rofname], A.[rofcontenttype], A.[rofresumefile],                              
--   A.[ronerone], A.[rosname], A.[roscontenttype],                               
--   A.[rosresumefile], A.[ronertwo], A.[rtwfileid],                              
--   A.[rtwcandidateid], A.[rtwfname], A.[rtwfcontenttype],                              
--   A.[rtwfresumefile], A.[rtworone], A.[rtwsname],                               
--   A.[rtwscontenttype], A.[rtwsresumefile], A.[rtwortwo],                              
--   A.[rthfileid], A.[rthcandidateid], A.[rthfname],                              
--   A.[rthfcontenttype], A.[rthfresumefile], A.[rthworone],                              
--   A.[rthsname], A.[rthscontenttype], A.[rthsresumefile],                              
--   A.[rthwortwo], A.[fileid], A.[rfcandidateid], A.[fname],                              
--   A.[fcontenttype], A.[fresumefile], A.[rfworone],                              
--   A.[sname], A.[scontenttype], A.[sresumefile],                              
--   A.[rfwortwo],                              
--   --A.[createdtime],                              
--   A.[docsubmissionallow]                                
--   FROM vw_rcalldata A                    
--    LEFT join trecruitpostlocationmap B on A.rspostid=B.postid and A.rslocid=B.locid               
--   Where  A.deptname Like @SearchValue +'%'   AND                            
--   convert(datetime,(convert(varchar, convert(datetime, A.aplicationdate, 103), 101)),111)                            
--   BETWEEN convert(datetime,(convert(varchar, convert(datetime, @startdate, 103), 101)),111) AND                             
--   convert(datetime,(convert(varchar, convert(datetime, @enddate, 103), 101)),111)                   
-- and A.rspostname not like 'ASSOCIATE%'                        
-- END                         
                         
--End                                  
--Else                                  
--Begin -- List Page Call                                  
--  Insert into @TB                                  
--  (SRL,registrationnumber, [backgroundcheck],             
--   [aplicationdate], [username],                               
--   [rscandidateid], [rscandidatename],                              
--   [resumefile], [applicationstatus],                               
--   [rspostname], [rspostid], [rslocid],                              
--   [location], [deptname], [deptdivision],                               
--   [referredus],[ReferredOthertext], [trakerid], [referenceno],                               
--   [departmentdivision], [departmentdivisonname],                              
--   [rtpostid], [rtpostname], [rtlocid], [headq],                              
--   [rtcandidateid], [rtcandidatename], [source],                               
--   [STARTDATE], [cvselected], [manualupdate],                               
--   [roneinterviewdate], [roneinterviewernameone],                              
--   [roneinterviewernametwo], [roneselect], [roneinterviewenddate],                                 
--   [rtwointerviewdate], [rtwointerviewernameone],                               
--   [rtwointerviewernametwo], [rtwoselect],[rtwointerviewenddate],                                
--   [rthreeinterviewdate], [rthreeinterviewernameone],                              
--   [rthreeinterviewernametwo], [rthreeselect], [rthreeinterviewenddate],                              
--   [frinterviewdate], [frinterviewernameone],                               
--   [frinterviewernametwo], [frselect],[Frinterviewenddate], [doo], [doj],                              
--   [empcode], [completionstatus], [timetaken],                               
--   [remarks], [createdby], [modifiedby],                              
--   --[modifiedtime],                 
--   [rofileid], [rocandidateid],                               
--   [rofname], [rofcontenttype], [rofresumefile],                              
--   [ronerone], [rosname], [roscontenttype],                               
--   [rosresumefile], [ronertwo], [rtwfileid],                              
--   [rtwcandidateid], [rtwfname], [rtwfcontenttype],                              
--   [rtwfresumefile], [rtworone], [rtwsname],                               
--   [rtwscontenttype], [rtwsresumefile], [rtwortwo],                              
--   [rthfileid], [rthcandidateid], [rthfname],                              
--   [rthfcontenttype], [rthfresumefile], [rthworone],                              
--   [rthsname], [rthscontenttype], [rthsresumefile],                              
--   [rthwortwo], [fileid], [rfcandidateid], [fname],                              
--   [fcontenttype], [fresumefile], [rfworone],                              
--   [sname], [scontenttype], [sresumefile],                              
--   [rfwortwo],                               
--   --[createdtime],                              
--   [docsubmissionallow]                              
--  )                                  
                              
--   SELECT ROW_NUMBER() OVER(ORDER BY A.registrationnumber desc)AS SRL,                                          
--      A.registrationnumber,[backgroundcheck],                               
--   A.[aplicationdate], A.[username],        
--   A.[rscandidateid], A.[rscandidatename] ,                              
--   A.[resumefile], A.[applicationstatus],                               
--   A.[rspostname], A.[rspostid], A.[rslocid],                              
--   A.[location], A.[deptname], A.[deptdivision],                               
--   A.[referredus],A.[ReferredOthertext], A.[trakerid], A.[referenceno],                               
--   A.[departmentdivision], A.[departmentdivisonname],                              
--   A.[rtpostid], A.[rtpostname], A.[rtlocid], A.[headq],                              
--   A.[rtcandidateid], A.[rtcandidatename], A.[source],                               
--   A.[STARTDATE], A.[cvselected], A.[manualupdate],                               
--   A.[roneinterviewdate], A.[roneinterviewernameone],                              
--   A.[roneinterviewernametwo], A.[roneselect], A.[roneinterviewenddate],                                 
--   A.[rtwointerviewdate], A.[rtwointerviewernameone],                               
--   A.[rtwointerviewernametwo], A.[rtwoselect], A.[rtwointerviewenddate],                               
--   A.[rthreeinterviewdate], A.[rthreeinterviewernameone],                              
--   A.[rthreeinterviewernametwo], A.[rthreeselect], A.[rthreeinterviewenddate],                             
--   A.[frinterviewdate], A.[frinterviewernameone],                               
--   A.[frinterviewernametwo], A.[frselect],A.[Frinterviewenddate], A.[doo], A.[doj],                              
--   A.[empcode], A.[completionstatus], A.[timetaken],                               
--   A.[remarks], A.[createdby], A.[modifiedby],                              
--   --A.[modifiedtime],                  
--   A.[rofileid], A.[rocandidateid],                               
--   A.[rofname], A.[rofcontenttype], A.[rofresumefile],          
--   A.[ronerone], A.[rosname], A.[roscontenttype],                               
--   A.[rosresumefile], A.[ronertwo], A.[rtwfileid],                              
--   A.[rtwcandidateid], A.[rtwfname], A.[rtwfcontenttype],                              
--   A.[rtwfresumefile], A.[rtworone], A.[rtwsname],                               
--   A.[rtwscontenttype], A.[rtwsresumefile], A.[rtwortwo],                              
--   A.[rthfileid], A.[rthcandidateid], A.[rthfname],                              
--   A.[rthfcontenttype], A.[rthfresumefile], A.[rthworone],                              
--   A.[rthsname], A.[rthscontenttype], A.[rthsresumefile],                              
--   A.[rthwortwo], A.[fileid], A.[rfcandidateid], A.[fname],                              
--   A.[fcontenttype], A.[fresumefile], A.[rfworone],                              
--   A.[sname], A.[scontenttype], A.[sresumefile],                          
--   A.[rfwortwo],                               
--   --A.[createdtime],                              
--   A.[docsubmissionallow]                              
--   FROM vw_rcalldata A                                               
--End                                  
                                  
                                  
-- -- Total Row                                          
-- Select @TotalRows=Isnull(Count(A.registrationnumber),0) from @TB  A                                        
                                       
-- -- Total Page                                       
-- Set  @TotalPage = ((@TotalRows/@RowsInPage)+1)                                      
                                      
-- -- Start Row No                                       
-- Set @StartNo =((@Pageno-1) * @RowsInPage)                                      
                                  
-- -- Data                                       
-- Select  A.* , @TotalPage TotalPage                                  
-- from  @TB   A                                  
-- Order By A.registrationnumber                               
-- Offset @StartNo Rows  Fetch Next @RowsInPage Rows Only                                       
                          
                                          
End     

GO

/* Functional group: 08_INTERVIEW; referenced grouped tables: tbl_Tracker_InterviewTaken_Details, tbl_Tracker_Status_Details */
/****** Object:  StoredProcedure [dbo].[proc_InterviewTaken_Details_Temp]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[proc_InterviewTaken_Details_Temp]  
@Action VARCHAR(50),  
@Plmapid varchar(10)=null,  
@id nvarchar(100)=null,  
@interviewTakenId nvarchar(max)=null,  
@candidatesName nvarchar(max)=null,  
@TInerviewDtls InterviewTaken_DetailsTableType 
READONLY , 
@CandidatesPsychometryReport varchar(max)=null,
@CandidateBackgroundVerificationReport varchar(max)=null,
@CandidateChallenges varchar(max)=null,
@Remarks varchar(max)=null,
@CandidateStatus varchar(max)=null

AS             
BEGIN            
  
     IF @Action = 'INSERT'              
 BEGIN               
  

   DELETE FROM tbl_Tracker_InterviewTaken_Details WHERE Plmapid = @Plmapid  
    DELETE FROM tbl_Tracker_Status_Details WHERE Plmapid = @Plmapid  


 --from tbl_Tracker_InterviewTaken_Details  
 Insert tbl_Tracker_InterviewTaken_Details(Plmapid,CandidatesName,InterviewTakenId)  
 Select Plmapid,CandidatesName,InterviewTakenId FROM @TInerviewDtls  

 INSERT INTO tbl_Tracker_Status_Details 
        (Plmapid, CandidatesPsychometryReport, CandidateBackgroundVerificationReport, CandidateChallenges, Remarks, CandidateStatus)
        values(
			@Plmapid,
            @CandidatesPsychometryReport,
            @CandidateBackgroundVerificationReport,
            @CandidateChallenges,
            @Remarks,
            @CandidateStatus)
        


 End  
   IF @Action = 'SELECT'              
  BEGIN    
    Select candi.Id,candi.Plmapid,candi.CandidatesName,candi.InterviewTakenId,(emp.empfirstname+' '+emp.empmiddlename+' '+emp.emplastname)InterviewerName,emp.empdept,Department  
  from tbl_Tracker_InterviewTaken_Details candi  
  Inner join  essp.dbo.Empbasic emp on emp.empno = candi.InterviewTakenId  
  Inner join  essp.dbo.Department dept on emp.empdept=dept.DepartmentId  
  where candi.Plmapid=@Plmapid;  
  END  
  IF @Action = 'UPDATE'              
 BEGIN   
   Update tbl_Tracker_InterviewTaken_Details   
   set CandidatesName=@candidatesName,InterviewTakenId=@interviewTakenId   
   where Id=@id  
 End  
 If @Action='DELETE'  
 BEGIN  
  DELETE tbl_Tracker_InterviewTaken_Details   where Id=@id  
 END  
End

GO

/* Functional group: 08_INTERVIEW; referenced grouped tables: tbl_recruitPostActiveInactivStatus, tbl_Tracker_InterviewTaken_Details, test, trecruitappliedpost */
/****** Object:  StoredProcedure [dbo].[Proc_RecruitmentTracker_temp]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Proc_RecruitmentTracker_temp]             
    @years VARCHAR(MAX),  
    @Month INT = NULL,  
    @selectWeek INT = NULL,                        
    @DeptId VARCHAR(MAX) = NULL,                        
    @PostId VARCHAR(MAX) = NULL,                        
    @LocationId VARCHAR(MAX) = NULL,      
    @postStatus INT = NULL      
AS            
BEGIN     


DECLARE @week INT = 5;  
--IF @years = CAST(YEAR(GETDATE()) AS VARCHAR(4))
--BEGIN
  
--END
--ELSE
--BEGIN
  
--END


 IF(@selectWeek <> NULL)  
 BEGIN  
   SET @week=@selectWeek  
 END  
    SET NOCOUNT ON;        
    WITH Months AS (  
        SELECT number AS MonthNum  
        FROM master.dbo.spt_values  
        WHERE type = 'P' AND number BETWEEN 1 AND 12  
    ),  
    AllWeekRanges AS (  
        SELECT   
            DATEADD(DAY, (ROW_NUMBER() OVER (PARTITION BY m.MonthNum ORDER BY v.number) - 1) * 7,   
                    DATEFROMPARTS(@years, m.MonthNum, 1)) AS WeekStart,  
            CASE   
                WHEN DATEADD(DAY, ((ROW_NUMBER() OVER (PARTITION BY m.MonthNum ORDER BY v.number) - 1) * 7) + 6,   
                             DATEFROMPARTS(@years, m.MonthNum, 1)) > EOMONTH(DATEFROMPARTS(@years, m.MonthNum, 1))  
                THEN EOMONTH(DATEFROMPARTS(@years, m.MonthNum, 1))  
                ELSE DATEADD(DAY, ((ROW_NUMBER() OVER (PARTITION BY m.MonthNum ORDER BY v.number) - 1) * 7) + 6,   
                             DATEFROMPARTS(@years, m.MonthNum, 1))  
            END AS WeekEnd,  
            ROW_NUMBER() OVER (PARTITION BY m.MonthNum ORDER BY v.number) AS WeekNumber,  
            m.MonthNum AS MonthNumber  
        FROM Months m  
        CROSS JOIN master.dbo.spt_values v  
        WHERE v.type = 'P'   
    ),  
    WeekRanges AS (  
        SELECT   
            FORMAT(DATEFROMPARTS(@years, MonthNumber, 1), 'MMM-yyyy') AS YearMonth,  
            MonthNumber,  
            FORMAT(WeekStart, 'yyyy-MM-dd') AS WeekStart,  
            FORMAT(WeekEnd, 'yyyy-MM-dd') AS WeekEnd,  
            WeekNumber  
        FROM AllWeekRanges  
        WHERE WeekNumber <= @week   
          AND WeekStart <= EOMONTH(DATEFROMPARTS(@years, MonthNumber, 1))  
          AND (@month IS NULL OR MonthNumber = @month)  
    ),  
    DeptIds AS (            
        SELECT CAST(Name AS INT) AS DeptId FROM dbo.splitstring(@DeptId)  
    ),  
    PostIds AS (            
        --SELECT CAST(Name AS INT) AS PostId FROM dbo.splitstring(@PostId)
		Select CAST(postid AS INT)AS PostId from trecruitappliedpost where ActualPostID IN (SELECT CAST(Name AS INT) FROM dbo.splitstring(@PostId))
		--Select postid from trecruitappliedpost where ActualPostID=1
    ),  
    LocationIds AS (            
        SELECT CAST(Name AS INT) AS LocationId FROM dbo.splitstring(@LocationId)  
    ),  
    PostDetails AS (            
        SELECT             
            B.plmapid,            
            B.deptname,            
            B.postname,            
            B.location,            
            B.Createdtime AS PostCreatedDate            
        FROM vw_Recruitment_AllPost B            
        WHERE B.Createdtime <= (SELECT MAX(WeekEnd) FROM WeekRanges)          
          AND (@DeptId IS NULL OR B.DeptId IN (SELECT DeptId FROM DeptIds))            
          AND (@PostId IS NULL OR B.postid IN (SELECT PostId FROM PostIds))             
          AND (@LocationId IS NULL OR B.locid IN (SELECT LocationId FROM LocationIds))  
      
    ),  
    PostStatus AS (            
        SELECT             
            A.plmapid,            
            A.ActiveInactiveDate,            
            A.Activeflag            
        FROM tbl_recruitPostActiveInactivStatus A            
        INNER JOIN PostDetails B ON A.Plmapid = B.plmapid              
    ),  
    PostWeekStatus AS (            
        SELECT             
            W.YearMonth AS YearAndMonth,  
            W.MonthNumber,  
            W.WeekNumber,            
            W.WeekStart,            
            W.WeekEnd,            
            P.plmapid,            
            P.deptname,            
            P.postname,            
            P.location,            
            P.PostCreatedDate,            
            ISNULL(  
                (SELECT TOP 1 CASE WHEN PS.Activeflag = 'Y' THEN 1 ELSE 0 END   
                 FROM PostStatus PS   
                 WHERE PS.plmapid = P.plmapid AND PS.ActiveInactiveDate <= W.WeekEnd   
                 ORDER BY PS.ActiveInactiveDate DESC), 0) AS Status,  
    (SELECT TOP 1 PS.ActiveInactiveDate   
     FROM PostStatus PS   
     WHERE PS.plmapid = P.plmapid AND PS.ActiveInactiveDate <= W.WeekEnd   
     ORDER BY PS.ActiveInactiveDate DESC) AS LastActiveInactiveDate  
        FROM WeekRanges W            
        CROSS JOIN PostDetails P  
    WHERE NOT (         P.PostCreatedDate =          (SELECT TOP 1 PS.ActiveInactiveDate           FROM PostStatus PS           WHERE PS.plmapid = P.plmapid AND PS.ActiveInactiveDate <= W.WeekEnd           ORDER BY PS.ActiveInactiveDate DESC)         AND 
EXISTS (             SELECT 1              FROM vw_Recruitment_AllPost              WHERE plmapid = P.plmapid AND status = 0    )   )  
  
    )  
    SELECT             
        A.plmapid,            
        A.YearAndMonth,    
        A.MonthNumber,  
        A.WeekNumber,            
        A.deptname,            
        A.postname,            
        A.location,            
        FORMAT(A.PostCreatedDate, 'dd-MM-yyyy') AS Createdtime,            
        (SELECT STUFF((SELECT DISTINCT ', ' + candi.CandidatesName                    
                       FROM tbl_Tracker_InterviewTaken_Details candi                    
                       WHERE candi.Plmapid = A.plmapid   
                         AND candi.InterviewYearMonth = A.YearAndMonth   
                         AND candi.InterviewWeekNumber = A.WeekNumber                   
                       FOR XML PATH('')), 1, 2, '')) AS CandidatesName,                    
        (SELECT STUFF((SELECT DISTINCT ', ' + emp.empfirstname + ' ' + emp.empmiddlename + ' ' + emp.emplastname                    
                       FROM tbl_Tracker_InterviewTaken_Details candi                    
                       INNER JOIN essp.dbo.Empbasic emp ON emp.empno = candi.InterviewTakenId                    
                       WHERE candi.Plmapid = A.plmapid   
                         AND candi.InterviewYearMonth = A.YearAndMonth   
                         AND candi.InterviewWeekNumber = A.WeekNumber                
                       FOR XML PATH('')), 1, 2, '')) AS InterviewerName,        
        B.CandidatesPsychometryReport,                        
        B.CandidateBackgroundVerificationReport,                        
        B.ChallengesName,                        
        B.Remarks,                        
        B.CandidateStatus,            
        A.Status,            
        A.WeekStart,            
        A.WeekEnd,  
        FORMAT(A.LastActiveInactiveDate, 'dd-MM-yyyy') AS ActiveInactiveDate    
    FROM PostWeekStatus A        
    LEFT JOIN tbl_Tracker_InterviewTaken_Details B          
        ON A.plmapid = B.Plmapid   
       AND B.InterviewYearMonth = A.YearAndMonth   
       AND B.InterviewWeekNumber = A.WeekNumber        
    WHERE     
      (@selectWeek IS NULL OR A.WeekNumber=@selectWeek)         
    -- and   postname = 'DEMO TEST FOR QA - DEMO - KOLKATA'  
      AND (@postStatus IS NULL OR A.Status = @postStatus)      
    GROUP BY     
        A.YearAndMonth,  
        A.plmapid,             
        A.MonthNumber,  
        A.WeekNumber,            
        A.deptname,            
        A.postname,            
        A.location,         
        A.PostCreatedDate,        
        B.CandidatesPsychometryReport,                        
        B.CandidateBackgroundVerificationReport,                        
        B.ChallengesName,                        
        B.Remarks,                        
        B.CandidateStatus,            
        A.Status,            
        A.WeekStart,            
        A.WeekEnd,  
        A.LastActiveInactiveDate   
    ORDER BY A.MonthNumber DESC, WeekNumber DESC, Status DESC, PostCreatedDate DESC;  
END  
GO

/* Functional group: 08_INTERVIEW; referenced grouped tables: Numbers, tbl_recruitPostActiveInactivStatus, tbl_Tracker_InterviewTaken_Details, trecruitappliedpost, trecruitdepartment, trecruitpostlocation */
/****** Object:  StoredProcedure [dbo].[Proc_RecruitmentTracker_temp_12_02_2025]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Proc_RecruitmentTracker_temp_12_02_2025]      
@years VARCHAR(MAX),          
    @Month INT = NULL,          
    @selectWeek INT = NULL,                                
    @DeptId VARCHAR(MAX) = NULL,                                
    @PostId VARCHAR(MAX) = NULL,                                
    @LocationId VARCHAR(MAX) = NULL,              
    @postStatus INT = NULL          
AS      
BEGIN      
DECLARE @SearchYear INT = CAST(@years AS INT); -- Set the year      
DECLARE @CurrentMonth INT ;      
DECLARE @TOMonth INT 
DECLARE @Today DATE=GETDATE()
IF @Month IS NOT NULL  BEGIN     SET @CurrentMonth = @Month;      SET @TOMonth = @Month; END ELSE  BEGIN     SET @CurrentMonth = 1;      SET @TOMonth = 12; END      
-- Temporary table to store results      
IF OBJECT_ID('tempdb..#FinalResults') IS NOT NULL      
    DROP TABLE #FinalResults;      
      
CREATE TABLE #FinalResults (      
    ActiveYear INT,      
    ActiveMonth INT,      
    MonthYear NVARCHAR(10), -- Added Month-Year column      
    WeekNum INT,      
    WeekStart DATE,      
    WeekEnd DATE,      
    plmapid INT,      
 postid Int,    
    DeptId INT,      
    locid INT,      
    postname NVARCHAR(255), -- Added postname column      
    Activeflag VARCHAR(10),      
    ActiveInactiveDate DATE      
);      
      
-- Loop through each month      
WHILE @CurrentMonth <= @TOMonth      
BEGIN      
    WITH WeekNumbers AS (      
        -- Generate week numbers for the selected month dynamically      
        SELECT       
            @SearchYear AS ActiveYear,      
            @CurrentMonth AS ActiveMonth,      
            FORMAT(DATEFROMPARTS(@SearchYear, @CurrentMonth, 1), 'MMM-yyyy') AS MonthYear, -- Generate Month-Year format      
            ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS WeekNum,      
            DATEADD(DAY, (ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1) * 7, DATEFROMPARTS(@SearchYear, @CurrentMonth, 1)) AS WeekStart      
        FROM master.dbo.spt_values       
        WHERE type = 'P' AND number BETWEEN 1 AND 6 -- Generates up to 6 weeks      
    )      
    SELECT       
        W.ActiveYear,       
        W.ActiveMonth,       
        W.MonthYear, -- Added formatted Month-Year column      
        W.WeekNum,       
        W.WeekStart,      
        CASE       
            WHEN DATEADD(DAY, 6, W.WeekStart) > EOMONTH(W.WeekStart)       
            THEN EOMONTH(W.WeekStart) -- Stop at the last day of the month      
            ELSE DATEADD(DAY, 6, W.WeekStart)      
        END AS WeekEnd      
    INTO #WeekData      
    FROM WeekNumbers W      
    WHERE W.WeekStart <= EOMONTH(DATEFROMPARTS(@SearchYear, @CurrentMonth, 1)) -- Ensure correct week count      
      AND (@SearchYear < YEAR(@Today) OR W.WeekStart <= @Today);
    WITH PostStatus AS (      
        -- Get all post status changes, including postname      
        SELECT       
            a.plmapid,    
   a.postid,    
            a.DeptId,       
            a.locid,       
            a.postname, -- Added postname column      
            b.ActiveInactiveDate,       
            b.Activeflag,       
            YEAR(b.ActiveInactiveDate) AS ActiveYear,       
            MONTH(b.ActiveInactiveDate) AS ActiveMonth      
        FROM vw_Recruitment_AllPost a       
        INNER JOIN tbl_recruitPostActiveInactivStatus b       
            ON b.plmapid = a.plmapid      
    ),      
    WeeklyPostStatus AS (      
        -- Match every post to each week and get the latest status up to that week      
        SELECT       
            W.ActiveYear, W.ActiveMonth, W.MonthYear, W.WeekNum, W.WeekStart, W.WeekEnd,      
            P.plmapid,P.postid, P.DeptId, P.locid, P.postname, P.Activeflag, P.ActiveInactiveDate,      
            ROW_NUMBER() OVER (PARTITION BY P.plmapid, W.WeekNum ORDER BY P.ActiveInactiveDate DESC) AS LatestStatus      
        FROM #WeekData W      
        LEFT JOIN PostStatus P      
            ON P.ActiveInactiveDate <= W.WeekEnd -- Get the latest status up to that week      
    ),      
    FilledWeeks AS (      
        -- Ensure only the latest status for each post per week      
        SELECT       
            ActiveYear, ActiveMonth, MonthYear, WeekNum, WeekStart, WeekEnd,      
            plmapid,postid, DeptId, locid, postname, Activeflag,       
   FORMAT(ActiveInactiveDate, 'yyyy-MM-dd') AS ActiveInactiveDate      
        FROM WeeklyPostStatus      
        WHERE LatestStatus = 1 -- Only keep the most recent status for the week      
    ),      
    FinalStatus AS (      
        -- Carry forward missing statuses to ensure continuity      
        SELECT       
            FW.ActiveYear,       
            FW.ActiveMonth,       
            FW.MonthYear,       
            FW.WeekNum,       
            FW.WeekStart,       
            FW.WeekEnd,      
            FW.plmapid,      
   FW.postid,    
            FW.DeptId,       
            FW.locid,       
            FW.postname,       
            COALESCE(FW.Activeflag,       
                     LAG(FW.Activeflag) OVER (PARTITION BY FW.plmapid ORDER BY FW.WeekNum)) AS Activeflag,      
            COALESCE(FW.ActiveInactiveDate,       
                     LAG(FW.ActiveInactiveDate) OVER (PARTITION BY FW.plmapid ORDER BY FW.WeekNum)) AS ActiveInactiveDate      
        FROM FilledWeeks FW      
    )      
    -- Insert monthly data into the temporary table      
    INSERT INTO #FinalResults      
    SELECT       
        ActiveYear, ActiveMonth, MonthYear, WeekNum, WeekStart, WeekEnd,       
        plmapid,postid, DeptId, locid, postname, Activeflag, ActiveInactiveDate      
    FROM FinalStatus;      
      
    -- Move to the next month      
    SET @CurrentMonth = @CurrentMonth + 1;      
      
    -- Drop temporary table after each loop      
    DROP TABLE IF EXISTS #WeekData;      
END      
 --Select * from  #FinalResults     
    
-- Final Output      
SELECT A.plmapid,A.postid, A.MonthYear, A.ActiveMonth, A.WeekNum, B.Deptname, A.postname,      
C.location,FORMAT( A.ActiveInactiveDate, 'dd-MM-yyyy') AS Createdtime,      
(SELECT STUFF((SELECT DISTINCT ', ' + candi.CandidatesName                            
               FROM tbl_Tracker_InterviewTaken_Details candi                            
               WHERE candi.Plmapid = A.plmapid           
                 AND candi.InterviewYearMonth = A.MonthYear COLLATE SQL_Latin1_General_CP1_CI_AS      
                 AND candi.InterviewWeekNumber = A.WeekNum                           
               FOR XML PATH('')), 1, 2, '')) AS CandidatesName,                            
(SELECT STUFF((SELECT DISTINCT ', ' + emp.empfirstname + ' ' + emp.empmiddlename + ' ' + emp.emplastname                            
               FROM tbl_Tracker_InterviewTaken_Details candi                            
               INNER JOIN essp.dbo.Empbasic emp     
                   ON emp.empno = candi.InterviewTakenId                            
               WHERE candi.Plmapid = A.plmapid           
                 AND candi.InterviewYearMonth = A.MonthYear COLLATE SQL_Latin1_General_CP1_CI_AS      
                 AND candi.InterviewWeekNumber = A.WeekNum                        
               FOR XML PATH('')), 1, 2, '')) AS InterviewerName,                
D.CandidatesPsychometryReport,                                
D.CandidateBackgroundVerificationReport,                                
D.ChallengesName,                                
D.Remarks,                                
D.CandidateStatus,      
CASE     
    WHEN A.Activeflag = 'Y' THEN 1       
    WHEN A.Activeflag = 'N' THEN 0     
END AS Status      
FROM #FinalResults A      
    
INNER JOIN trecruitdepartment B     
    ON B.id = A.DeptId -- Removed COLLATE from INT column comparison      
INNER JOIN trecruitpostlocation C     
    ON C.locid = A.locid -- Removed COLLATE from INT column comparison      
LEFT JOIN tbl_Tracker_InterviewTaken_Details D                 
    ON A.plmapid = D.Plmapid           
   AND D.InterviewYearMonth = A.MonthYear COLLATE SQL_Latin1_General_CP1_CI_AS           
   AND D.InterviewWeekNumber = A.WeekNum     
       
WHERE (@selectWeek IS NULL OR A.WeekNum=@selectWeek)       
    and (@DeptId IS NULL OR A.DeptId IN (SELECT CAST(Name AS INT) AS DeptId FROM dbo.splitstring(@DeptId) ))      
 AND (@PostId IS NULL OR A.postid IN (Select CAST(postid AS INT)AS PostId from trecruitappliedpost where ActualPostID IN (SELECT CAST(Name AS INT) FROM dbo.splitstring(@PostId)) ))        
 AND (@LocationId IS NULL OR A.locid IN (SELECT CAST(Name AS INT) AS LocationId FROM dbo.splitstring(@LocationId)))  
 And(@postStatus IS NULL OR A.Activeflag=CASE     
    WHEN @postStatus = 1 THEN 'Y'       
    WHEN @postStatus = 0 THEN 'N'     
END)
 --AND (@postStatus IS NULL OR A.Activeflag IN (SELECT CAST(Name AS INT) AS LocationId FROM dbo.splitstring(@postStatus)))
GROUP BY      
    A.plmapid,A.postid, A.MonthYear, A.ActiveMonth, A.WeekNum, B.Deptname, A.postname,      
    C.location, A.ActiveInactiveDate,     
    D.CandidatesPsychometryReport,                                
    D.CandidateBackgroundVerificationReport,                                
    D.ChallengesName,                                
    D.Remarks,                                
    D.CandidateStatus,    
    A.Activeflag    
          
--ActiveMonth = 6 -- Uncomment to filter by month      
 ORDER BY  A.ActiveMonth desc, A.WeekNum desc, plmapid desc;      
-- Clean up      
DROP TABLE #FinalResults;      
END      
GO

/* Functional group: 08_INTERVIEW; referenced grouped tables: Numbers, tbl_recruitPostActiveInactivStatus, tbl_Tracker_InterviewTaken_Details, trecruitappliedpost */
/****** Object:  StoredProcedure [dbo].[Proc_RecruitmentTracker_temp_2025]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Proc_RecruitmentTracker_temp_2025]
    @years VARCHAR(4),
    @Month INT = NULL,
    @selectWeek INT = NULL,
    @DeptId VARCHAR(MAX) = NULL,
    @PostId VARCHAR(MAX) = NULL,
    @LocationId VARCHAR(MAX) = NULL,
    @postStatus INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @week INT = 5;
    IF @selectWeek IS NOT NULL
        SET @week = @selectWeek;

    DECLARE @intYear INT = CAST(@years AS INT);
    DECLARE @maxWeekEnd DATE;

    -- Generate a temporary WeekMonth table to replace master.dbo.spt_values
    DECLARE @WeekMonth TABLE (WeekNum INT, MonthNum INT);

    INSERT INTO @WeekMonth (WeekNum, MonthNum)
    SELECT n1.Number AS WeekNum, n2.Number AS MonthNum
    FROM (SELECT Number FROM Numbers WHERE Number BETWEEN 1 AND 5) n1
    CROSS JOIN (SELECT Number FROM Numbers WHERE Number BETWEEN 1 AND 12) n2;

    -- Precompute max week end to avoid multiple calculations
    SELECT @maxWeekEnd = MAX(WeekEnd)
    FROM (
        SELECT DATEADD(DAY, (WeekNum - 1) * 7 + 6, DATEFROMPARTS(@intYear, MonthNum, 1)) AS WeekEnd
        FROM @WeekMonth
    ) AS WeekData;

    -- Store filtered values in temp tables for better performance
    CREATE TABLE #DeptIds (DeptId INT);
    INSERT INTO #DeptIds SELECT CAST(Name AS INT) FROM dbo.splitstring(@DeptId);

    CREATE TABLE #PostIds (PostId INT);
    INSERT INTO #PostIds 
    SELECT postid 
    FROM trecruitappliedpost 
    WHERE ActualPostId IN (SELECT CAST(Name AS INT) FROM dbo.splitstring(@PostId));

    CREATE TABLE #LocationIds (LocationId INT);
    INSERT INTO #LocationIds SELECT CAST(Name AS INT) FROM dbo.splitstring(@LocationId);

    -- Precompute filtered posts for faster joins
CREATE TABLE #PostDetails (
    plmapid INT PRIMARY KEY,
    deptname NVARCHAR(255),
    postname NVARCHAR(255),
    location NVARCHAR(255),
    Status NVARCHAR(255),
    PostCreatedDate DATE,
    LastActiveInactiveDate DATE -- Fixed: Now included
);

INSERT INTO #PostDetails
SELECT B.plmapid, B.deptname, B.postname, B.location, B.status, B.Createdtime, 
       (SELECT TOP 1 PS.ActiveInactiveDate 
        FROM tbl_recruitPostActiveInactivStatus PS 
        WHERE PS.plmapid = B.plmapid 
        ORDER BY PS.ActiveInactiveDate DESC) AS LastActiveInactiveDate
		FROM vw_Recruitment_AllPost B
		WHERE B.Createdtime <= @maxWeekEnd
    AND (@DeptId IS NULL OR B.DeptId IN (SELECT DeptId FROM #DeptIds))
    AND (@PostId IS NULL OR B.postid IN (SELECT PostId FROM #PostIds))
    AND (@LocationId IS NULL OR B.locid IN (SELECT LocationId FROM #LocationIds));



    -- Index PostDetails temp table
    CREATE INDEX IX_PostDetails ON #PostDetails(plmapid);

    -- Precompute status
    CREATE TABLE #PostStatus (
        plmapid INT,
        ActiveInactiveDate DATE,
        Activeflag CHAR(1)
    );

    INSERT INTO #PostStatus
    SELECT A.plmapid, A.ActiveInactiveDate, A.Activeflag
    FROM tbl_recruitPostActiveInactivStatus A
    INNER JOIN #PostDetails B ON A.Plmapid = B.plmapid;

	
    CREATE INDEX IX_PostStatus ON #PostStatus(plmapid, ActiveInactiveDate DESC);

    -- Compute final result using joins instead of subqueries
    SELECT
        A.plmapid, 
        W.YearMonth, 
        W.MonthNumber, 
        W.WeekNumber, 
        A.deptname, 
        A.postname, 
        A.location,
        FORMAT(A.PostCreatedDate, 'dd-MM-yyyy') AS Createdtime,
        -- Fixing the incorrect reference to candi
        (SELECT STRING_AGG(CandidatesName, ', ') 
         FROM tbl_Tracker_InterviewTaken_Details candi
         WHERE candi.Plmapid = A.plmapid 
         AND candi.InterviewYearMonth = W.YearMonth 
         AND candi.InterviewWeekNumber = W.WeekNumber) AS CandidatesName,
        -- Fixing the incorrect reference to emp
        (SELECT STRING_AGG(emp.empfirstname + ' ' + emp.empmiddlename + ' ' + emp.emplastname, ', ') 
         FROM tbl_Tracker_InterviewTaken_Details candi
         INNER JOIN essp.dbo.Empbasic emp ON emp.empno = candi.InterviewTakenId
         WHERE candi.Plmapid = A.plmapid 
         AND candi.InterviewYearMonth = W.YearMonth 
         AND candi.InterviewWeekNumber = W.WeekNumber) AS InterviewerName,
        B.CandidatesPsychometryReport, 
        B.CandidateBackgroundVerificationReport, 
        B.ChallengesName, 
        B.Remarks,
        B.CandidateStatus, 
        A.Status, 
        W.WeekStart, 
        W.WeekEnd, 
        FORMAT(A.LastActiveInactiveDate, 'dd-MM-yyyy') AS ActiveInactiveDate
    FROM #PostDetails A
    JOIN (
        SELECT 
            FORMAT(DATEFROMPARTS(@intYear, MonthNum, 1), 'MMM-yyyy') AS YearMonth,
            MonthNum AS MonthNumber,
            WeekNum AS WeekNumber,
            DATEADD(DAY, (WeekNum - 1) * 7, DATEFROMPARTS(@intYear, MonthNum, 1)) AS WeekStart,
            CASE 
                WHEN DATEADD(DAY, (WeekNum - 1) * 7 + 6, DATEFROMPARTS(@intYear, MonthNum, 1)) > @maxWeekEnd 
                THEN @maxWeekEnd 
                ELSE DATEADD(DAY, (WeekNum - 1) * 7 + 6, DATEFROMPARTS(@intYear, MonthNum, 1)) 
            END AS WeekEnd
        FROM @WeekMonth
    ) W ON 1=1
    LEFT JOIN tbl_Tracker_InterviewTaken_Details B ON A.plmapid = B.Plmapid 
        AND B.InterviewYearMonth = W.YearMonth 
        AND B.InterviewWeekNumber = W.WeekNumber
    LEFT JOIN essp.dbo.Empbasic emp ON emp.empno = B.InterviewTakenId
    WHERE (@selectWeek IS NULL OR W.WeekNumber = @selectWeek)
        AND (@postStatus IS NULL OR A.Status = @postStatus)
    GROUP BY A.plmapid,B.CandidatesPsychometryReport,B.CandidateBackgroundVerificationReport,
	B.ChallengesName,B.Remarks,B.CandidateStatus,
	W.YearMonth, W.MonthNumber, W.WeekNumber, A.deptname, A.postname, A.location, A.PostCreatedDate, A.Status, W.WeekStart, W.WeekEnd, A.LastActiveInactiveDate
	Order by W.MonthNumber Desc

    DROP TABLE #DeptIds, #PostIds, #LocationIds, #PostDetails, #PostStatus;
END;

--Select  * from tbl_Tracker_InterviewTaken_Details
GO

/* Functional group: 08_INTERVIEW; referenced grouped tables: tbl_recruitPostActiveInactivStatus, tbl_Tracker_InterviewTaken_Details, trecruitappliedpost */
/****** Object:  StoredProcedure [dbo].[Proc_RecruitmentTracker_temp_ONE]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Proc_RecruitmentTracker_temp_ONE]
    @years VARCHAR(10),    
    @Month INT = NULL,    
    @selectWeek INT = NULL,                          
    @DeptId VARCHAR(MAX) = NULL,                          
    @PostId VARCHAR(MAX) = NULL,                          
    @LocationId VARCHAR(MAX) = NULL,        
    @postStatus INT = NULL        
AS    
BEGIN    
    SET NOCOUNT ON;

    -- Define default week value
    DECLARE @week INT = ISNULL(@selectWeek, 5);

    -- Temporary table for Week Ranges
    CREATE TABLE #WeekRanges (
        YearMonth VARCHAR(10),
        MonthNumber INT,
        WeekNumber INT,
        WeekStart DATE,
        WeekEnd DATE
    );

    -- Insert Week Ranges
    INSERT INTO #WeekRanges
    SELECT 
        FORMAT(DATEFROMPARTS(@years, number, 1), 'MMM-yyyy') AS YearMonth,    
        number AS MonthNumber,    
        ROW_NUMBER() OVER (PARTITION BY number ORDER BY number) AS WeekNumber,
        DATEADD(DAY, (ROW_NUMBER() OVER (PARTITION BY number ORDER BY number) - 1) * 7, 
                DATEFROMPARTS(@years, number, 1)) AS WeekStart,    
        CASE     
            WHEN DATEADD(DAY, ((ROW_NUMBER() OVER (PARTITION BY number ORDER BY number) - 1) * 7) + 6, 
                        DATEFROMPARTS(@years, number, 1)) > EOMONTH(DATEFROMPARTS(@years, number, 1))    
            THEN EOMONTH(DATEFROMPARTS(@years, number, 1))    
            ELSE DATEADD(DAY, ((ROW_NUMBER() OVER (PARTITION BY number ORDER BY number) - 1) * 7) + 6, 
                        DATEFROMPARTS(@years, number, 1))    
        END    
    FROM (
        SELECT number, ROW_NUMBER() OVER (PARTITION BY number ORDER BY number) AS RowNum
        FROM master.dbo.spt_values    
        WHERE type = 'P' AND number BETWEEN 1 AND 12
    ) AS WeekData
    WHERE (@month IS NULL OR number = @month) AND RowNum <= @week;

    -- Temporary table for Post Details
    CREATE TABLE #PostDetails (
        plmapid INT PRIMARY KEY,
        deptname VARCHAR(255),
        postname VARCHAR(255),
        location VARCHAR(255),
        PostCreatedDate DATE
    );

    -- Insert into PostDetails
    INSERT INTO #PostDetails
    SELECT 
        B.plmapid,              
        B.deptname,              
        B.postname,              
        B.location,              
        B.Createdtime 
    FROM vw_Recruitment_AllPost B              
    WHERE B.Createdtime <= (SELECT MAX(WeekEnd) FROM #WeekRanges)
    AND (@DeptId IS NULL OR B.DeptId IN (SELECT CAST(Name AS INT) FROM dbo.splitstring(@DeptId)))
    AND (@PostId IS NULL OR B.postid IN (SELECT CAST(postid AS INT) FROM trecruitappliedpost WHERE ActualPostID IN (SELECT CAST(Name AS INT) FROM dbo.splitstring(@PostId))))
    AND (@LocationId IS NULL OR B.locid IN (SELECT CAST(Name AS INT) FROM dbo.splitstring(@LocationId)));

    -- Temporary table for Post Status
    CREATE TABLE #PostStatus (
        plmapid INT,
        ActiveInactiveDate DATE,
        Activeflag CHAR(1)
    );

    -- Insert into PostStatus
    INSERT INTO #PostStatus
    SELECT 
        A.plmapid,              
        A.ActiveInactiveDate,              
        A.Activeflag              
    FROM tbl_recruitPostActiveInactivStatus A              
    INNER JOIN #PostDetails B ON A.Plmapid = B.plmapid;

    -- Final Query to retrieve data
    SELECT                
        A.plmapid,              
        A.YearMonth,      
        A.MonthNumber,    
        A.WeekNumber,              
        A.deptname,              
        A.postname,              
        A.location,              
        FORMAT(A.PostCreatedDate, 'dd-MM-yyyy') AS Createdtime,  
        
        -- Use STRING_AGG instead of STUFF for better performance      
        (SELECT STRING_AGG(candi.CandidatesName, ', ') 
         FROM tbl_Tracker_InterviewTaken_Details candi
         WHERE candi.Plmapid = A.plmapid     
         AND candi.InterviewYearMonth = A.YearMonth     
         AND candi.InterviewWeekNumber = A.WeekNumber) AS CandidatesName,    
           
        (SELECT STRING_AGG(emp.empfirstname + ' ' + emp.empmiddlename + ' ' + emp.emplastname, ', ') 
         FROM tbl_Tracker_InterviewTaken_Details candi                      
         INNER JOIN essp.dbo.Empbasic emp ON emp.empno = candi.InterviewTakenId                      
         WHERE candi.Plmapid = A.plmapid     
         AND candi.InterviewYearMonth = A.YearMonth     
         AND candi.InterviewWeekNumber = A.WeekNumber) AS InterviewerName,          
        
        B.CandidatesPsychometryReport,                          
        B.CandidateBackgroundVerificationReport,                          
        B.ChallengesName,                          
        B.Remarks,                          
        B.CandidateStatus,              
        A.Status,              
        A.WeekStart,              
        A.WeekEnd,    
        FORMAT(A.LastActiveInactiveDate, 'dd-MM-yyyy') AS ActiveInactiveDate      
    FROM (
        SELECT  
            W.YearMonth,      
            W.MonthNumber,    
            W.WeekNumber,              
            W.WeekStart,              
            W.WeekEnd,              
            P.plmapid,              
            P.deptname,              
            P.postname,              
            P.location,              
            P.PostCreatedDate,              
            ISNULL(    
                (SELECT TOP 1 CASE WHEN PS.Activeflag = 'Y' THEN 1 ELSE 0 END     
                 FROM #PostStatus PS     
                 WHERE PS.plmapid = P.plmapid AND PS.ActiveInactiveDate <= W.WeekEnd     
                 ORDER BY PS.ActiveInactiveDate DESC), 0) AS Status,    
            (SELECT TOP 1 PS.ActiveInactiveDate     
             FROM #PostStatus PS     
             WHERE PS.plmapid = P.plmapid AND PS.ActiveInactiveDate <= W.WeekEnd     
             ORDER BY PS.ActiveInactiveDate DESC) AS LastActiveInactiveDate    
        FROM #WeekRanges W              
        CROSS JOIN #PostDetails P    
        WHERE NOT (P.PostCreatedDate = (SELECT TOP 1 PS.ActiveInactiveDate 
                                        FROM #PostStatus PS 
                                        WHERE PS.plmapid = P.plmapid 
                                        AND PS.ActiveInactiveDate <= W.WeekEnd 
                                        ORDER BY PS.ActiveInactiveDate DESC) 
        AND EXISTS (SELECT 1 FROM vw_Recruitment_AllPost WHERE plmapid = P.plmapid AND status = 0))
    ) A          
    LEFT JOIN tbl_Tracker_InterviewTaken_Details B            
    ON A.plmapid = B.Plmapid     
    AND B.InterviewYearMonth = A.YearMonth     
    AND B.InterviewWeekNumber = A.WeekNumber          
    WHERE       
      (@selectWeek IS NULL OR A.WeekNumber = @selectWeek)           
      AND (@postStatus IS NULL OR A.Status = @postStatus)        
    ORDER BY A.MonthNumber DESC, A.WeekNumber DESC, A.Status DESC, A.PostCreatedDate DESC;    

    -- Drop temporary tables
    DROP TABLE #WeekRanges;
    DROP TABLE #PostDetails;
    DROP TABLE #PostStatus;
END;

GO

/* Functional group: 08_INTERVIEW; referenced grouped tables: tbl_Tracker_InterviewTaken_Details */
/****** Object:  StoredProcedure [dbo].[Proc_RecruitmentTracker_temp_patit]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Proc_RecruitmentTracker_temp_patit]          
    @Date VARCHAR(MAX) = NULL,          
    @Week VARCHAR(MAX) = NULL,          
    @DeptId VARCHAR(MAX) = NULL,          
    @PostId VARCHAR(MAX) = NULL,          
    @LocationId VARCHAR(MAX) = NULL          
AS          
BEGIN          
  --Only Interview        
           
      DECLARE @Month INT, @Year INT, @FirstDayOfMonth DATE, @FirstDayOfWeek DATE, @LastDayOfWeek DATE;          
          
    DECLARE @MonthName VARCHAR(3) = LEFT(@Date, CHARINDEX('-', @Date) - 1);            
    DECLARE @YearSuffix VARCHAR(2) = RIGHT(@Date, 2);          
    SET @Month = MONTH(CAST('01-' + @MonthName + '-2000' AS DATETIME));          
    SET @Year = 2000 + CAST(@YearSuffix AS INT);          
          
    SET @FirstDayOfMonth = DATEFROMPARTS(@Year, @Month, 1);          
          
    DECLARE @WeekInt INT = CAST(@Week AS INT);          
    SET @FirstDayOfWeek = DATEADD(WEEK, @WeekInt - 1, @FirstDayOfMonth);          
    SET @LastDayOfWeek = DATEADD(DAY, 6 - DATEPART(WEEKDAY, @FirstDayOfWeek) + 1, @FirstDayOfWeek);          
          
    DECLARE @LastDayOfMonth DATE = EOMONTH(@FirstDayOfMonth);          
    IF @LastDayOfWeek > @LastDayOfMonth          
    BEGIN          
        SET @LastDayOfWeek = @LastDayOfMonth;          
    END          
          
   -- SELECT @LastDayOfWeek AS LastDayOfWeek          
 Select M.*        
 FRom (        
    SELECT          
        allPost.plmapid,          
        --CAST(LEFT(DATENAME(MONTH, CONVERT(DATETIME, candi.CreatedDate, 103)), 3) + '-' + CAST(YEAR(CONVERT(DATETIME, candi.CreatedDate, 103)) AS VARCHAR(4)) AS VARCHAR) AS YearMonth,          
        --((DAY(candi.CreatedDate) - 1) / 7) + 1 AS WeekNumber,  
		--@Date YearMonth,

	CASE 
        WHEN @Date IS NULL THEN CAST(LEFT(DATENAME(MONTH, CONVERT(DATETIME, candi.CreatedDate, 103)), 3) + '-' + 
                                      CAST(YEAR(CONVERT(DATETIME, candi.CreatedDate, 103)) AS VARCHAR(4)) AS VARCHAR)
        ELSE @Date
    END AS YearMonth,

	CASE 
        WHEN @Week IS NULL THEN ((DAY(candi.CreatedDate) - 1) / 7) + 1 
        ELSE @Week
    END AS WeekNumber,

		--@Week WeekNumber,
        allPost.deptname,          
        allPost.postname,          
        allPost.location,          
        FORMAT(allPost.Createdtime, 'dd-MM-yyyy') AS Createdtime,     
        allPost.ActinveDate,  
       (SELECT STUFF((SELECT DISTINCT ', ' + candi.CandidatesName          
                       FROM tbl_Tracker_InterviewTaken_Details candi          
                       WHERE candi.Plmapid = allPost.plmapid          
                       FOR XML PATH('')), 1, 2, '')) AS CandidatesName,          
          
  (SELECT STUFF((SELECT DISTINCT ', ' + emp.empfirstname + ' ' + emp.empmiddlename + ' ' + emp.emplastname          
               FROM tbl_Tracker_InterviewTaken_Details candi          
               INNER JOIN essp.dbo.Empbasic emp ON emp.empno = candi.InterviewTakenId          
               WHERE candi.Plmapid = allPost.plmapid          
               FOR XML PATH('')), 1, 2, '')) AS InterviewerName,          
   --      FROM tbl_Tracker_InterviewTaken_Details candi          
   --      WHERE candi.Plmapid = allPost.plmapid) AS CandidatesName          
          
  -------------------------Status Display--------------------------------------          
	   candi.CandidatesPsychometryReport,          
	   candi.CandidateBackgroundVerificationReport,          
	   candi.ChallengesName,          
	   candi.Remarks,          
	   candi.CandidateStatus,          
 ------------------------------------          
 ----------Active or not Status----------          
 allPost.status, 1 RowStatus        
     -------------------------------         
  FROM           
        vw_Recruitment_AllPost allPost          
  Inner join tbl_Tracker_InterviewTaken_Details as candi          
  on candi.Plmapid=allPost.plmapid          
           
 WHERE          
        1 = CASE           
  -- Only For Dept          
          
                WHEN @DeptId IS NOT NULL AND @PostId IS NULL AND @LocationId IS NULL and @Date is null and @Week is null THEN           
  CASE WHEN allPost.DeptId IN (SELECT Name FROM dbo.splitstring(@DeptId)) THEN 1 ELSE 0 END          
            
  --For Dept and Post          
      WHEN @DeptId IS NOT NULL AND @PostId IS NOT NULL AND @LocationId IS NULL and @Date is null and @Week is null THEN           
                    CASE WHEN allPost.DeptId IN (SELECT Name FROM dbo.splitstring(@DeptId))           
                             AND allPost.PostId IN (SELECT Name FROM dbo.splitstring(@PostId))           
 THEN 1 ELSE 0 END          
   -- For Dept & Post & Location          
                WHEN @DeptId IS NOT NULL AND @PostId IS NOT NULL AND @LocationId IS NOT NULL and @Date is null and @Week is null THEN           
                    CASE WHEN allPost.DeptId IN (SELECT Name FROM dbo.splitstring(@DeptId))           
                             AND allPost.PostId IN (SELECT Name FROM dbo.splitstring(@PostId))           
                             AND allPost.locid IN (SELECT Name FROM dbo.splitstring(@LocationId))          
                        THEN 1 ELSE 0 END          
          
      -- For Date                 
       WHEN @Date IS NOT NULL AND @Week IS NULL AND @DeptId IS NULL AND @PostId IS NULL AND @LocationId IS NULL THEN          
     CASE WHEN     
  --(LEFT(DATENAME(MONTH, CONVERT(DATETIME, candi.CreatedDate, 103)), 3) + '-' +           
  --           CAST(YEAR(CONVERT(DATETIME, candi.CreatedDate, 103)) AS VARCHAR(4))) = @Date     
    CONVERT(DATETIME, candi.CreatedDate, 103) <= EOMONTH(CONVERT(DATETIME, '01-' + @Date, 105))    
           THEN  1           
     ELSE 0          
     end          
          
-----------------------------when pass Only Date then show all record upto current month---------------------------          
   --WHEN @Date IS NOT NULL AND @Week IS NULL AND @DeptId IS NULL AND @PostId IS NULL AND @LocationId IS NULL THEN          
   --  CASE   WHEN CONVERT(DATETIME, allPost.Createdtime, 103) <= EOMONTH(CONVERT(DATETIME, '01-' + @Date, 105))          
   --       --  AND   CONVERT(DATETIME, candi.CreatedDate, 103) <= EOMONTH(CONVERT(DATETIME, '01-' + @Date, 105))           
   --  THEN 1          
   -- ELSE 0           
   --END          
          
-------------------------------------------------------------------------------------------------          
          
  -- For Date & Week          
     WHEN @Date IS NOT NULL AND @Week IS NOT NULL AND @DeptId IS NULL AND @PostId IS NULL AND @LocationId IS NULL THEN           
                    CASE WHEN     
     CONVERT(DATETIME, candi.CreatedDate, 103) <= EOMONTH(CONVERT(DATETIME, '01-' +@Date, 105))    
                       AND (CONVERT(DATETIME, candi.CreatedDate, 103) <= @LastDayOfWeek)        
     --(LEFT(DATENAME(MONTH, CONVERT(DATETIME, candi.CreatedDate, 103)), 3) +'-' + CAST(YEAR(CONVERT(DATETIME, candi.CreatedDate, 103)) AS VARCHAR(4))) = @Date          
        --AND ((DAY(CONVERT(DATETIME, candi.CreatedDate, 103)) - 1) / 7) + 1 = @Week          
                        THEN 1 ELSE 0           
      END          
 ---------------------------------------------------------------------------------------------------------          
   -- For Date & Week & Dept          
    WHEN @Date IS NOT NULL AND @Week IS NOT NULL AND @DeptId IS not NULL AND @PostId IS NULL AND @LocationId IS NULL THEN           
               CASE WHEN (LEFT(DATENAME(MONTH, CONVERT(DATETIME, candi.CreatedDate, 103)), 3) +'-' + CAST(YEAR(CONVERT(DATETIME, candi.CreatedDate, 103)) AS VARCHAR(4))) = @Date          
       -- CASE WHEN CONVERT(DATETIME, allPost.Createdtime, 103) <= EOMONTH(CONVERT(DATETIME, '01-' +@Date, 105))          
         --AND   CONVERT(DATETIME, candi.CreatedDate, 103) <= EOMONTH(CONVERT(DATETIME, '01-' + @Date, 105))          
                             AND ((DAY(CONVERT(DATETIME, candi.CreatedDate, 103)) - 1) / 7) + 1 = @Week          
      --  AND (CONVERT(DATETIME, allPost.Createdtime, 103) <= @LastDayOfWeek)          
        and allPost.DeptId IN(SELECT Name FROM dbo.splitstring(@DeptId))          
                        THEN 1 ELSE 0 END          
          
          
     -- For Date & Dept          
      WHEN @Date IS NOT NULL AND @Week IS NULL AND @DeptId IS not NULL AND @PostId IS NULL AND @LocationId IS NULL THEN           
     CASE          
       WHEN (LEFT(DATENAME(MONTH, CONVERT(DATETIME, candi.CreatedDate, 103)), 3) +'-' + CAST(YEAR(CONVERT(DATETIME, candi.CreatedDate, 103)) AS VARCHAR(4))) = @Date          
      --   WHEN CONVERT(DATETIME, allPost.Createdtime, 103) <= EOMONTH(CONVERT(DATETIME, '01-' +@Date, 105))          
        and allPost.DeptId IN (SELECT Name FROM dbo.splitstring(@DeptId))          
                        THEN 1 ELSE 0 END          
          
      ---date dept and post          
       WHEN @Date IS NOT NULL AND @Week IS NULL AND @DeptId IS not NULL AND @PostId IS not null AND @LocationId IS NULL THEN           
        CASE WHEN (LEFT(DATENAME(MONTH, CONVERT(DATETIME, candi.CreatedDate, 103)), 3) +'-' + CAST(YEAR(CONVERT(DATETIME, candi.CreatedDate, 103)) AS VARCHAR(4))) = @Date          
       --  CASE WHEN CONVERT(DATETIME, allPost.Createdtime, 103) <= EOMONTH(CONVERT(DATETIME, '01-' +@Date, 105))          
          -- AND   CONVERT(DATETIME, candi.CreatedDate, 103) <= EOMONTH(CONVERT(DATETIME, '01-' + @Date, 105))          
        and allPost.DeptId IN (SELECT Name FROM dbo.splitstring(@DeptId))          
      AND allPost.PostId IN (SELECT Name FROM dbo.splitstring(@PostId))          
                        THEN 1 ELSE 0 END          
          
      --date dept and post and location          
       WHEN @Date IS NOT NULL AND @Week IS NULL AND @DeptId IS not NULL AND @PostId IS not null AND @LocationId IS not NULL THEN           
                          CASE WHEN (LEFT(DATENAME(MONTH, CONVERT(DATETIME, candi.CreatedDate, 103)), 3) +'-' + CAST(YEAR(CONVERT(DATETIME, candi.CreatedDate, 103)) AS VARCHAR(4))) = @Date          
       -- CASE WHEN CONVERT(DATETIME, allPost.Createdtime, 103) <= EOMONTH(CONVERT(DATETIME, '01-' +@Date, 105))          
        -- AND   CONVERT(DATETIME, candi.CreatedDate, 103) <= EOMONTH(CONVERT(DATETIME, '01-' + @Date, 105))          
        and allPost.DeptId IN (SELECT Name FROM dbo.splitstring(@DeptId))          
        AND allPost.PostId IN (SELECT Name FROM dbo.splitstring(@PostId))          
         AND allPost.locid IN (SELECT Name FROM dbo.splitstring(@LocationId))          
                        THEN 1 ELSE 0           
     END          
          
      -- For Date & Week & Dept & post          
    WHEN @Date IS NOT NULL AND @Week IS NOT NULL AND @DeptId IS not NULL AND @PostId IS not null AND @LocationId IS NULL THEN           
                     CASE WHEN (LEFT(DATENAME(MONTH, CONVERT(DATETIME, candi.CreatedDate, 103)), 3) +'-' + CAST(YEAR(CONVERT(DATETIME, candi.CreatedDate, 103)) AS VARCHAR(4))) = @Date          
       -- CASE  WHEN CONVERT(DATETIME, allPost.Createdtime, 103) <= EOMONTH(CONVERT(DATETIME, '01-' +@Date, 105))          
        AND ((DAY(CONVERT(DATETIME, candi.CreatedDate, 103)) - 1) / 7) + 1 <= @Week          
       -- AND (CONVERT(DATETIME, allPost.Createdtime, 103) <= @LastDayOfWeek)          
        and allPost.DeptId IN (SELECT Name FROM dbo.splitstring(@DeptId))          
        AND allPost.PostId IN (SELECT Name FROM dbo.splitstring(@PostId))          
                        THEN 1 ELSE 0 END          
          
      -- For Date & week & dept & post & location          
       WHEN @Date IS NOT NULL AND @Week IS NOT NULL AND @DeptId IS not NULL AND @PostId IS not null AND @LocationId IS not NULL THEN           
                    --CASE  WHEN CONVERT(DATETIME, allPost.Createdtime, 103) <= EOMONTH(CONVERT(DATETIME, '01-' +@Date, 105))          
                      CASE WHEN (LEFT(DATENAME(MONTH, CONVERT(DATETIME, candi.CreatedDate, 103)), 3) +'-' + CAST(YEAR(CONVERT(DATETIME, candi.CreatedDate, 103)) AS VARCHAR(4))) = @Date          
        AND ((DAY(CONVERT(DATETIME, candi.CreatedDate, 103)) - 1) / 7) + 1 <= @Week             
      -- AND (CONVERT(DATETIME, allPost.Createdtime, 103) <= @LastDayOfWeek)          
        and allPost.DeptId IN (SELECT Name FROM dbo.splitstring(@DeptId))          
      AND allPost.PostId IN (SELECT Name FROM dbo.splitstring(@PostId))          
         AND allPost.locid IN (SELECT Name FROM dbo.splitstring(@LocationId))          
                        THEN 1 ELSE 0 END          
          
      -- for date & dept & Post & location          
      WHEN @Date IS NOT NULL AND @Week IS NULL AND @DeptId IS not NULL AND @PostId IS not null AND @LocationId IS not NULL THEN           
                    CASE WHEN (LEFT(DATENAME(MONTH, CONVERT(DATETIME, candi.CreatedDate, 103)), 3) +'-' + CAST(YEAR(CONVERT(DATETIME, candi.CreatedDate, 103)) AS VARCHAR(4))) = @Date          
                          -- AND   CONVERT(DATETIME, candi.CreatedDate, 103) <= EOMONTH(CONVERT(DATETIME, '01-' + @Date, 105))          
           and allPost.DeptId IN (SELECT Name FROM dbo.splitstring(@DeptId))          
        AND allPost.PostId IN (SELECT Name FROM dbo.splitstring(@PostId))          
         AND allPost.locid IN (SELECT Name FROM dbo.splitstring(@LocationId))          
                        THEN 1 ELSE 0 END          
          
          
      -- for date & dept & Post & location          
      WHEN @Date IS NOT NULL AND @Week IS NULL AND @DeptId IS not NULL AND @PostId IS not null AND @LocationId IS not NULL THEN           
                    CASE WHEN (LEFT(DATENAME(MONTH, CONVERT(DATETIME, candi.CreatedDate, 103)), 3) +'-' + CAST(YEAR(CONVERT(DATETIME, candi.CreatedDate, 103)) AS VARCHAR(4))) = @Date          
                          -- AND   CONVERT(DATETIME, candi.CreatedDate, 103) <= EOMONTH(CONVERT(DATETIME, '01-' + @Date, 105))              
       and allPost.DeptId IN (SELECT Name FROM dbo.splitstring(@DeptId))          
        AND allPost.PostId IN (SELECT Name FROM dbo.splitstring(@PostId))          
         AND allPost.locid IN (SELECT Name FROM dbo.splitstring(@LocationId))          
                        THEN 1 ELSE 0 END          
          
          
          
      -- For Default orNot select or Page Load          
      WHEN @Date IS NULL AND @Week IS NULL AND @DeptId IS NULL AND @PostId IS null AND @LocationId IS NULL THEN           
          
                    CASE WHEN           
     --allPost.Createdtime >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0) -- First day of current month          
     -- AND allPost.Createdtime < DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) + 1, 0)           
      candi.CreatedDate <=GETDATE()           
                        THEN 1           
          
          
          
    ELSE 0 END          
                ELSE 0          
          
            END          
   GROUP BY          
        allPost.plmapid,          
  --allPost.CandidatesName,          
        allPost.deptname,          
        allPost.postname,          
        allPost.location,          
        allPost.Createdtime,          
   candi.CandidatesPsychometryReport,          
  candi.CandidateBackgroundVerificationReport,          
  candi.ChallengesName,          
   candi.Remarks,          
   candi.CandidateStatus,          
   allPost.status,          
   candi.CreatedDate,         
  allPost.ActinveDate  
  UNION ALL        
        
  SELECT          
        allPost.plmapid,          
      --CAST(LEFT(DATENAME(MONTH, CONVERT(DATETIME, allPost.ActinveDate, 103)), 3) + '-' + CAST(YEAR(CONVERT(DATETIME, allPost.ActinveDate, 103)) AS VARCHAR(4)) AS VARCHAR) AS YearMonth,          
      --  ((DAY(allPost.ActinveDate) - 1) / 7) + 1 AS WeekNumber,   
	  CASE 
        WHEN @Date IS NULL THEN CAST(LEFT(DATENAME(MONTH, CONVERT(DATETIME, allPost.ActinveDate, 103)), 3) + '-' + 
                                      CAST(YEAR(CONVERT(DATETIME, allPost.ActinveDate, 103)) AS VARCHAR(4)) AS VARCHAR)
        ELSE @Date
    END AS YearMonth,
	  	--@Date YearMonth,
		CASE 
        WHEN @Week IS NULL THEN ((DAY(allPost.ActinveDate) - 1) / 7) + 1 
        ELSE @Week
    END AS WeekNumber,

		--@Week WeekNumber,
        allPost.deptname,          
        allPost.postname,          
        allPost.location,          
        FORMAT(allPost.Createdtime, 'dd-MM-yyyy') AS Createdtime,          
          allPost.ActinveDate,  
  null AS CandidatesName,          
  null as InterviewerName,        
  null as CandidatesPsychometryReport,          
  null CandidateBackgroundVerificationReport,          
  null ChallengesName,          
  null Remarks,          
  null CandidateStatus,          
 ------------------------------------          
 ----------Active or not Status----------          
 allPost.status ,2 RowStatus        
     -------------------------------          
  FROM           
        vw_Recruitment_AllPost allPost          
         
 WHERE          
        1 = CASE           
  -- Only For Dept          
          
                WHEN @DeptId IS NOT NULL AND @PostId IS NULL AND @LocationId IS NULL and @Date is null and @Week is null THEN           
                    CASE WHEN allPost.DeptId IN (SELECT Name FROM dbo.splitstring(@DeptId)) THEN 1 ELSE 0 END          
         --For Dept and Post          
      WHEN @DeptId IS NOT NULL AND @PostId IS NOT NULL AND @LocationId IS NULL and @Date is null and @Week is null THEN           
                    CASE WHEN allPost.DeptId IN (SELECT Name FROM dbo.splitstring(@DeptId))           
                             AND allPost.PostId IN (SELECT Name FROM dbo.splitstring(@PostId))           
                        THEN 1 ELSE 0 END          
  -- For Dept & Post & Location          
                WHEN @DeptId IS NOT NULL AND @PostId IS NOT NULL AND @LocationId IS NOT NULL and @Date is null and @Week is null THEN           
                    CASE WHEN allPost.DeptId IN (SELECT Name FROM dbo.splitstring(@DeptId))           
                             AND allPost.PostId IN (SELECT Name FROM dbo.splitstring(@PostId))           
                             AND allPost.locid IN (SELECT Name FROM dbo.splitstring(@LocationId))          
                        THEN 1 ELSE 0 END          
          
-- For Date                 
       WHEN @Date IS NOT NULL AND @Week IS NULL AND @DeptId IS NULL AND @PostId IS NULL AND @LocationId IS NULL THEN          
     CASE WHEN     
  --(LEFT(DATENAME(MONTH, CONVERT(DATETIME, allPost.Createdtime, 103)), 3) + '-' +           
  --           CAST(YEAR(CONVERT(DATETIME, allPost.Createdtime, 103)) AS VARCHAR(4))) = @Date     
    CONVERT(DATETIME, allPost.ActinveDate, 103) <= EOMONTH(CONVERT(DATETIME, '01-' + @Date, 105))      
    and allpost.status=1    
           THEN  1           
     ELSE 0          
     end          
          
        
-------------------------------------------------------------------------------------------------          
          
  -- For Date & Week          
     WHEN @Date IS NOT NULL AND @Week IS NOT NULL AND @DeptId IS NULL AND @PostId IS NULL AND @LocationId IS NULL THEN           
                    CASE WHEN CONVERT(DATETIME, allPost.ActinveDate, 103) <= EOMONTH(CONVERT(DATETIME, '01-' +@Date, 105))    
       AND (CONVERT(DATETIME, allPost.ActinveDate, 103) <= @LastDayOfWeek)    
       and allPost.status=1    
     --(LEFT(DATENAME(MONTH, CONVERT(DATETIME, allPost.Createdtime, 103)), 3) +'-' + CAST(YEAR(CONVERT(DATETIME, allPost.Createdtime, 103)) AS VARCHAR(4))) = @Date          
                            -- AND ((DAY(CONVERT(DATETIME, allPost.Createdtime, 103)) - 1) / 7) + 1 = @Week       
                        THEN 1 ELSE 0           
      END          
 ---------------------------------------------------------------------------------------------------------          
   -- For Date & Week & Dept          
    WHEN @Date IS NOT NULL AND @Week IS NOT NULL AND @DeptId IS not NULL AND @PostId IS NULL AND @LocationId IS NULL THEN           
               CASE WHEN (LEFT(DATENAME(MONTH, CONVERT(DATETIME, allPost.ActinveDate, 103)), 3) +'-' + CAST(YEAR(CONVERT(DATETIME, allPost.ActinveDate, 103)) AS VARCHAR(4))) = @Date          
       -- CASE WHEN CONVERT(DATETIME, allPost.Createdtime, 103) <= EOMONTH(CONVERT(DATETIME, '01-' +@Date, 105))          
         --AND   CONVERT(DATETIME, candi.CreatedDate, 103) <= EOMONTH(CONVERT(DATETIME, '01-' + @Date, 105))          
                             AND ((DAY(CONVERT(DATETIME, allPost.ActinveDate, 103)) - 1) / 7) + 1 = @Week          
      --  AND (CONVERT(DATETIME, allPost.Createdtime, 103) <= @LastDayOfWeek)          
        and allPost.DeptId IN(SELECT Name FROM dbo.splitstring(@DeptId)) and allpost.status=1    
                        THEN 1 ELSE 0 END          
          
          
     -- For Date & Dept          
      WHEN @Date IS NOT NULL AND @Week IS NULL AND @DeptId IS not NULL AND @PostId IS NULL AND @LocationId IS NULL THEN           
     CASE          
       WHEN (LEFT(DATENAME(MONTH, CONVERT(DATETIME, allPost.ActinveDate, 103)), 3) +'-' + CAST(YEAR(CONVERT(DATETIME, allPost.ActinveDate, 103)) AS VARCHAR(4))) = @Date          
      --   WHEN CONVERT(DATETIME, allPost.Createdtime, 103) <= EOMONTH(CONVERT(DATETIME, '01-' +@Date, 105))          
        and allPost.DeptId IN (SELECT Name FROM dbo.splitstring(@DeptId)) and allpost.status=1         
                        THEN 1 ELSE 0 END          
          
      ---date dept and post          
       WHEN @Date IS NOT NULL AND @Week IS NULL AND @DeptId IS not NULL AND @PostId IS not null AND @LocationId IS NULL THEN           
        CASE WHEN (LEFT(DATENAME(MONTH, CONVERT(DATETIME, allPost.ActinveDate, 103)), 3) +'-' + CAST(YEAR(CONVERT(DATETIME, allPost.ActinveDate, 103)) AS VARCHAR(4))) = @Date          
       --  CASE WHEN CONVERT(DATETIME, allPost.Createdtime, 103) <= EOMONTH(CONVERT(DATETIME, '01-' +@Date, 105))          
          -- AND   CONVERT(DATETIME, candi.CreatedDate, 103) <= EOMONTH(CONVERT(DATETIME, '01-' + @Date, 105))          
        and allPost.DeptId IN (SELECT Name FROM dbo.splitstring(@DeptId))          
        AND allPost.PostId IN (SELECT Name FROM dbo.splitstring(@PostId)) and allpost.status=1        
                        THEN 1 ELSE 0 END          
          
      --date dept and post and location          
       WHEN @Date IS NOT NULL AND @Week IS NULL AND @DeptId IS not NULL AND @PostId IS not null AND @LocationId IS not NULL THEN           
                          CASE WHEN (LEFT(DATENAME(MONTH, CONVERT(DATETIME, allPost.ActinveDate, 103)), 3) +'-' + CAST(YEAR(CONVERT(DATETIME, allPost.ActinveDate, 103)) AS VARCHAR(4))) = @Date          
       -- CASE WHEN CONVERT(DATETIME, allPost.Createdtime, 103) <= EOMONTH(CONVERT(DATETIME, '01-' +@Date, 105))          
        -- AND   CONVERT(DATETIME, candi.CreatedDate, 103) <= EOMONTH(CONVERT(DATETIME, '01-' + @Date, 105))          
        and allPost.DeptId IN (SELECT Name FROM dbo.splitstring(@DeptId))          
        AND allPost.PostId IN (SELECT Name FROM dbo.splitstring(@PostId))          
         AND allPost.locid IN (SELECT Name FROM dbo.splitstring(@LocationId)) and allpost.status=1         
                        THEN 1 ELSE 0           
     END          
          
      -- For Date & Week & Dept & post          
    WHEN @Date IS NOT NULL AND @Week IS NOT NULL AND @DeptId IS not NULL AND @PostId IS not null AND @LocationId IS NULL THEN           
                     CASE WHEN (LEFT(DATENAME(MONTH, CONVERT(DATETIME, allPost.ActinveDate, 103)), 3) +'-' + CAST(YEAR(CONVERT(DATETIME, allPost.ActinveDate, 103)) AS VARCHAR(4))) = @Date          
       -- CASE  WHEN CONVERT(DATETIME, allPost.Createdtime, 103) <= EOMONTH(CONVERT(DATETIME, '01-' +@Date, 105))          
        AND ((DAY(CONVERT(DATETIME, allPost.ActinveDate, 103)) - 1) / 7) + 1 <= @Week          
       -- AND (CONVERT(DATETIME, allPost.Createdtime, 103) <= @LastDayOfWeek)          
        and allPost.DeptId IN (SELECT Name FROM dbo.splitstring(@DeptId))          
        AND allPost.PostId IN (SELECT Name FROM dbo.splitstring(@PostId)) and allpost.status=1          
                        THEN 1 ELSE 0 END          
          
      -- For Date & week & dept & post & location          
       WHEN @Date IS NOT NULL AND @Week IS NOT NULL AND @DeptId IS not NULL AND @PostId IS not null AND @LocationId IS not NULL THEN           
                    --CASE  WHEN CONVERT(DATETIME, allPost.Createdtime, 103) <= EOMONTH(CONVERT(DATETIME, '01-' +@Date, 105))          
                      CASE WHEN (LEFT(DATENAME(MONTH, CONVERT(DATETIME, allPost.ActinveDate, 103)), 3) +'-' + CAST(YEAR(CONVERT(DATETIME, allPost.ActinveDate, 103)) AS VARCHAR(4))) = @Date          
        AND ((DAY(CONVERT(DATETIME, allPost.ActinveDate, 103)) - 1) / 7) + 1 <= @Week             
      -- AND (CONVERT(DATETIME, allPost.Createdtime, 103) <= @LastDayOfWeek)          
  and allPost.DeptId IN (SELECT Name FROM dbo.splitstring(@DeptId))          
      AND allPost.PostId IN (SELECT Name FROM dbo.splitstring(@PostId))          
         AND allPost.locid IN (SELECT Name FROM dbo.splitstring(@LocationId)) and allpost.status=1         
                        THEN 1 ELSE 0 END          
          
      -- for date & dept & Post & location          
      WHEN @Date IS NOT NULL AND @Week IS NULL AND @DeptId IS not NULL AND @PostId IS not null AND @LocationId IS not NULL THEN           
                    CASE WHEN (LEFT(DATENAME(MONTH, CONVERT(DATETIME, allPost.ActinveDate, 103)), 3) +'-' + CAST(YEAR(CONVERT(DATETIME, allPost.ActinveDate, 103)) AS VARCHAR(4))) = @Date          
      -- AND   CONVERT(DATETIME, candi.CreatedDate, 103) <= EOMONTH(CONVERT(DATETIME, '01-' + @Date, 105))          
           and allPost.DeptId IN (SELECT Name FROM dbo.splitstring(@DeptId))          
        AND allPost.PostId IN (SELECT Name FROM dbo.splitstring(@PostId))          
         AND allPost.locid IN (SELECT Name FROM dbo.splitstring(@LocationId)) and allpost.status=1         
                        THEN 1 ELSE 0 END          
          
          
      -- for date & dept & Post & location          
      WHEN @Date IS NOT NULL AND @Week IS NULL AND @DeptId IS not NULL AND @PostId IS not null AND @LocationId IS not NULL THEN           
                    CASE WHEN (LEFT(DATENAME(MONTH, CONVERT(DATETIME, allPost.ActinveDate, 103)), 3) +'-' + CAST(YEAR(CONVERT(DATETIME, allPost.ActinveDate, 103)) AS VARCHAR(4))) = @Date          
                          -- AND   CONVERT(DATETIME, candi.CreatedDate, 103) <= EOMONTH(CONVERT(DATETIME, '01-' + @Date, 105))              
       and allPost.DeptId IN (SELECT Name FROM dbo.splitstring(@DeptId))          
        AND allPost.PostId IN (SELECT Name FROM dbo.splitstring(@PostId))          
         AND allPost.locid IN (SELECT Name FROM dbo.splitstring(@LocationId)) and allpost.status=1          
                        THEN 1 ELSE 0 END          
        
      -- For Default orNot select or Page Load          
      WHEN @Date IS NULL AND @Week IS NULL AND @DeptId IS NULL AND @PostId IS null AND @LocationId IS NULL THEN           
          CASE WHEN                 
      allPost.ActinveDate <=GETDATE() and allPost.status=1          
                        THEN 1           
        
    ELSE 0 END          
                ELSE 0          
          
            END          
   GROUP BY          
        allPost.plmapid,          
           
        allPost.deptname,          
        allPost.postname,          
        allPost.location,          
        allPost.Createdtime,    
  allPost.ActinveDate,           
   allPost.status        
   ) M         
  ORDER BY M.RowStatus ,M.ActinveDate desc     
   --ORDER BY M.ActinveDate desc       
END          
GO

/* Functional group: 08_INTERVIEW; referenced grouped tables: Numbers, tbl_recruitPostActiveInactivStatus, tbl_Tracker_InterviewTaken_Details, test, trecruitappliedpost */
/****** Object:  StoredProcedure [dbo].[Proc_RecruitmentTracker_temp_TESTT]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Proc_RecruitmentTracker_temp_TESTT]               
    @years VARCHAR(10),    
    @Month INT = NULL,    
    @selectWeek INT = NULL,                          
    @DeptId VARCHAR(MAX) = NULL,                          
    @PostId VARCHAR(MAX) = NULL,                          
    @LocationId VARCHAR(MAX) = NULL,        
    @postStatus INT = NULL        
AS              
BEGIN       
  DECLARE @SearchYear INT = cast(@years As Int); -- Set the year
DECLARE @CurrentMonth INT = 1;


-- Temporary table to store results
IF OBJECT_ID('tempdb..#FinalResults') IS NOT NULL
    DROP TABLE #FinalResults;

CREATE TABLE #FinalResults (
    ActiveYear INT,
    ActiveMonth INT,
    WeekNum INT,
    WeekStart DATE,
    WeekEnd DATE,
    plmapid INT,
    DeptId INT,
    locid INT,
    postname NVARCHAR(255), -- Added postname column
    Activeflag VARCHAR(10),
    ActiveInactiveDate DATE
);

-- Loop through each month
WHILE @CurrentMonth <= 12
BEGIN
    WITH WeekNumbers AS (
        -- Generate week numbers for the selected month dynamically
        SELECT 
            @SearchYear AS ActiveYear,
            @CurrentMonth AS ActiveMonth,
            ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS WeekNum,
            DATEADD(DAY, (ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1) * 7, DATEFROMPARTS(@SearchYear, @CurrentMonth, 1)) AS WeekStart
        FROM master.dbo.spt_values 
        WHERE type = 'P' AND number BETWEEN 1 AND 6 -- Generates up to 6 weeks
    )
    SELECT 
        W.ActiveYear, 
        W.ActiveMonth, 
        W.WeekNum, 
        W.WeekStart,
        CASE 
            WHEN DATEADD(DAY, 6, W.WeekStart) > EOMONTH(W.WeekStart) 
            THEN EOMONTH(W.WeekStart) -- Stop at the last day of the month
            ELSE DATEADD(DAY, 6, W.WeekStart)
        END AS WeekEnd
    INTO #WeekData
    FROM WeekNumbers W
    WHERE W.WeekStart <= EOMONTH(DATEFROMPARTS(@SearchYear, @CurrentMonth, 1)); -- Ensure correct week count

    WITH PostStatus AS (
        -- Get all post status changes, including postname
        SELECT 
            a.plmapid, 
            a.DeptId, 
            a.locid, 
            a.postname, -- Added postname column
            b.ActiveInactiveDate, 
            b.Activeflag, 
            YEAR(b.ActiveInactiveDate) AS ActiveYear, 
            MONTH(b.ActiveInactiveDate) AS ActiveMonth
        FROM vw_Recruitment_AllPost a 
        INNER JOIN tbl_recruitPostActiveInactivStatus b 
            ON b.plmapid = a.plmapid
    ),
    WeeklyPostStatus AS (
        -- Match every post to each week and get the latest status up to that week
        SELECT 
            W.ActiveYear, W.ActiveMonth, W.WeekNum, W.WeekStart, W.WeekEnd,
            P.plmapid, P.DeptId, P.locid, P.postname, P.Activeflag, P.ActiveInactiveDate,
            ROW_NUMBER() OVER (PARTITION BY P.plmapid, W.WeekNum ORDER BY P.ActiveInactiveDate DESC) AS LatestStatus
        FROM #WeekData W
        LEFT JOIN PostStatus P
            ON P.ActiveInactiveDate <= W.WeekEnd -- Get the latest status up to that week
    ),
    FilledWeeks AS (
        -- Ensure only the latest status for each post per week
        SELECT 
            ActiveYear, ActiveMonth, WeekNum, WeekStart, WeekEnd,
            plmapid, DeptId, locid, postname, Activeflag, 
            FORMAT(ActiveInactiveDate, 'yyyy-MM-dd') AS ActiveInactiveDate
        FROM WeeklyPostStatus
        WHERE LatestStatus = 1 -- Only keep the most recent status for the week
    ),
    FinalStatus AS (
        -- Carry forward missing statuses to ensure continuity
        SELECT 
            FW.ActiveYear, FW.ActiveMonth, FW.WeekNum, FW.WeekStart, FW.WeekEnd,
            FW.plmapid, FW.DeptId, FW.locid, FW.postname, 
            COALESCE(FW.Activeflag, LAG(FW.Activeflag) OVER (PARTITION BY FW.plmapid ORDER BY FW.WeekNum)) AS Activeflag,
            COALESCE(FW.ActiveInactiveDate, LAG(FW.ActiveInactiveDate) OVER (PARTITION BY FW.plmapid ORDER BY FW.WeekNum)) AS ActiveInactiveDate
        FROM FilledWeeks FW
    )
    -- Insert monthly data into the temporary table
    INSERT INTO #FinalResults
    SELECT 
        ActiveYear, ActiveMonth, WeekNum, WeekStart, WeekEnd, 
        plmapid, DeptId, locid, postname, Activeflag, ActiveInactiveDate
    FROM FinalStatus;

    -- Move to the next month
    SET @CurrentMonth = @CurrentMonth + 1;

    -- Drop temporary table after each loop
    DROP TABLE IF EXISTS #WeekData;
END

-- Final Output
SELECT * FROM #FinalResults 
--WHERE ActiveMonth = 6 -- Uncomment to filter by month
ORDER BY ActiveYear, ActiveMonth, WeekNum, plmapid;

-- Clean up
DROP TABLE #FinalResults;


  
--DECLARE @week INT = 5;    
----IF @years = CAST(YEAR(GETDATE()) AS VARCHAR(4)) --BEGIN    --END --ELSE --BEGIN    --END  
  
  
-- IF(@selectWeek <> NULL)    
-- BEGIN    
--   SET @week=@selectWeek    
-- END    
--    SET NOCOUNT ON;          
--    WITH Months AS (    
--        SELECT number AS MonthNum    
--        FROM master.dbo.spt_values    
--        WHERE type = 'P' AND number BETWEEN 1 AND 12    
--    ),    
--    AllWeekRanges AS (    
--        SELECT     
--            DATEADD(DAY, (ROW_NUMBER() OVER (PARTITION BY m.MonthNum ORDER BY v.number) - 1) * 7,     
--                    DATEFROMPARTS(@years, m.MonthNum, 1)) AS WeekStart,    
--            CASE     
--                WHEN DATEADD(DAY, ((ROW_NUMBER() OVER (PARTITION BY m.MonthNum ORDER BY v.number) - 1) * 7) + 6,     
--                             DATEFROMPARTS(@years, m.MonthNum, 1)) > EOMONTH(DATEFROMPARTS(@years, m.MonthNum, 1))    
--                THEN EOMONTH(DATEFROMPARTS(@years, m.MonthNum, 1))    
--                ELSE DATEADD(DAY, ((ROW_NUMBER() OVER (PARTITION BY m.MonthNum ORDER BY v.number) - 1) * 7) + 6,     
--                             DATEFROMPARTS(@years, m.MonthNum, 1))    
--            END AS WeekEnd,    
--            ROW_NUMBER() OVER (PARTITION BY m.MonthNum ORDER BY v.number) AS WeekNumber,    
--            m.MonthNum AS MonthNumber    
--        FROM Months m    
--        CROSS JOIN master.dbo.spt_values v    
--        WHERE v.type = 'P'     
--    ),    
--    WeekRanges AS (    
--        SELECT     
--            FORMAT(DATEFROMPARTS(@years, MonthNumber, 1), 'MMM-yyyy') AS YearMonth,    
--            MonthNumber,    
--            FORMAT(WeekStart, 'yyyy-MM-dd') AS WeekStart,    
--            FORMAT(WeekEnd, 'yyyy-MM-dd') AS WeekEnd,    
--            WeekNumber    
--        FROM AllWeekRanges    
--        WHERE WeekNumber <= @week     
--          AND WeekStart <= EOMONTH(DATEFROMPARTS(@years, MonthNumber, 1))    
--          AND (@month IS NULL OR MonthNumber = @month)    
--    ),    
--    DeptIds AS (              
--        SELECT CAST(Name AS INT) AS DeptId FROM dbo.splitstring(@DeptId)    
--    ),    
--    PostIds AS (              
--        --SELECT CAST(Name AS INT) AS PostId FROM dbo.splitstring(@PostId)  
--  Select CAST(postid AS INT)AS PostId from trecruitappliedpost where ActualPostID IN (SELECT CAST(Name AS INT) FROM dbo.splitstring(@PostId))  
--  --Select postid from trecruitappliedpost where ActualPostID=1  
--    ),    
--    LocationIds AS (              
--        SELECT CAST(Name AS INT) AS LocationId FROM dbo.splitstring(@LocationId)    
--    ),    
--    PostDetails AS (              
--        SELECT               
--            B.plmapid,              
--            B.deptname,              
--            B.postname,              
--            B.location,              
--            B.Createdtime AS PostCreatedDate              
--        FROM vw_Recruitment_AllPost B              
--        WHERE B.Createdtime <= (SELECT MAX(WeekEnd) FROM WeekRanges)            
--          AND (@DeptId IS NULL OR B.DeptId IN (SELECT DeptId FROM DeptIds))              
--          AND (@PostId IS NULL OR B.postid IN (SELECT PostId FROM PostIds))               
--          AND (@LocationId IS NULL OR B.locid IN (SELECT LocationId FROM LocationIds))    
        
--    ),    
--    PostStatus AS (              
--        SELECT               
--            A.plmapid,              
--            A.ActiveInactiveDate,              
--            A.Activeflag              
--        FROM tbl_recruitPostActiveInactivStatus A              
--        INNER JOIN PostDetails B ON A.Plmapid = B.plmapid                
--    ),    
--    PostWeekStatus AS (              
--        SELECT               
--            W.YearMonth AS YearAndMonth,                W.MonthNumber,    
--            W.WeekNumber,              
--            W.WeekStart,              
--            W.WeekEnd,              
--            P.plmapid,              
--            P.deptname,              
--            P.postname,              
--            P.location,              
--            P.PostCreatedDate,              
--            ISNULL(    
--                (SELECT TOP 1 CASE WHEN PS.Activeflag = 'Y' THEN 1 ELSE 0 END     
--                 FROM PostStatus PS     
--                 WHERE PS.plmapid = P.plmapid AND PS.ActiveInactiveDate <= W.WeekEnd     
--                 ORDER BY PS.ActiveInactiveDate DESC), 0) AS Status,    
--    (SELECT TOP 1 PS.ActiveInactiveDate     
--     FROM PostStatus PS     
--     WHERE PS.plmapid = P.plmapid AND PS.ActiveInactiveDate <= W.WeekEnd     
--     ORDER BY PS.ActiveInactiveDate DESC) AS LastActiveInactiveDate    
--        FROM WeekRanges W              
--    CROSS JOIN PostDetails P    
--    WHERE NOT (P.PostCreatedDate = (SELECT TOP 1 PS.ActiveInactiveDate FROM PostStatus PS  WHERE PS.plmapid = P.plmapid AND PS.ActiveInactiveDate <= W.WeekEnd  ORDER BY PS.ActiveInactiveDate DESC)    
--	AND EXISTS ( SELECT 1  FROM vw_Recruitment_AllPost   WHERE plmapid = P.plmapid AND status = 0))
--    )    
--    SELECT               
--        A.plmapid,              
--        A.YearAndMonth,      
--        A.MonthNumber,    
--        A.WeekNumber,              
--        A.deptname,              
--        A.postname,              
--        A.location,              
--        FORMAT(A.PostCreatedDate, 'dd-MM-yyyy') AS Createdtime,              
--        (SELECT STUFF((SELECT DISTINCT ', ' + candi.CandidatesName                      
--                       FROM tbl_Tracker_InterviewTaken_Details candi                      
--                       WHERE candi.Plmapid = A.plmapid     
--                         AND candi.InterviewYearMonth = A.YearAndMonth     
--                         AND candi.InterviewWeekNumber = A.WeekNumber                     
--                       FOR XML PATH('')), 1, 2, '')) AS CandidatesName,                      
--        (SELECT STUFF((SELECT DISTINCT ', ' + emp.empfirstname + ' ' + emp.empmiddlename + ' ' + emp.emplastname                      
--                       FROM tbl_Tracker_InterviewTaken_Details candi                      
--                       INNER JOIN essp.dbo.Empbasic emp ON emp.empno = candi.InterviewTakenId                      
--                       WHERE candi.Plmapid = A.plmapid     
--                         AND candi.InterviewYearMonth = A.YearAndMonth     
--                         AND candi.InterviewWeekNumber = A.WeekNumber                  
--                       FOR XML PATH('')), 1, 2, '')) AS InterviewerName,          
--        B.CandidatesPsychometryReport,                          
--        B.CandidateBackgroundVerificationReport,                          
--        B.ChallengesName,                          
--        B.Remarks,                          
--        B.CandidateStatus,              
--        A.Status,              
--        A.WeekStart,              
--        A.WeekEnd,    
--        FORMAT(A.LastActiveInactiveDate, 'dd-MM-yyyy') AS ActiveInactiveDate      
--    FROM PostWeekStatus A          
--    LEFT JOIN tbl_Tracker_InterviewTaken_Details B            
--        ON A.plmapid = B.Plmapid     
--       AND B.InterviewYearMonth = A.YearAndMonth     
--       AND B.InterviewWeekNumber = A.WeekNumber          
--    WHERE       
--      (@selectWeek IS NULL OR A.WeekNumber=@selectWeek)           
--    -- and   postname = 'DEMO TEST FOR QA - DEMO - KOLKATA'    
--      AND (@postStatus IS NULL OR A.Status = @postStatus)        
--    GROUP BY       
--        A.YearAndMonth,    
--        A.plmapid,               
--        A.MonthNumber,    
--        A.WeekNumber,              
--        A.deptname,              
--        A.postname,              
--        A.location,           
--        A.PostCreatedDate,          
--        B.CandidatesPsychometryReport,                          
--        B.CandidateBackgroundVerificationReport,                          
--        B.ChallengesName,                          
--        B.Remarks,                          
--        B.CandidateStatus,              
--        A.Status,              
--        A.WeekStart,              
--        A.WeekEnd,    
--        A.LastActiveInactiveDate     
--    ORDER BY A.MonthNumber DESC, WeekNumber DESC, Status DESC, PostCreatedDate DESC;    
END    
GO

/* Functional group: 08_INTERVIEW; referenced grouped tables: tbl_Tracker_InterviewTaken_Details */
/****** Object:  StoredProcedure [dbo].[Recr_track_temp]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[Recr_track_temp] @Date='Jan-2025'
CREATE PROCEDURE [dbo].[Recr_track_temp]  
    @Date VARCHAR(MAX) = NULL,  
    @Week VARCHAR(MAX) = NULL,  
    @DeptId VARCHAR(MAX) = NULL,  
    @PostId VARCHAR(MAX) = NULL,  
    @LocationId VARCHAR(MAX) = NULL  
AS  
BEGIN  


SELECT  
        allPost.plmapid,  
      CAST(LEFT(DATENAME(MONTH, CONVERT(DATETIME, allPost.Createdtime, 103)), 3) + '-' + CAST(YEAR(CONVERT(DATETIME, allPost.Createdtime, 103)) AS VARCHAR(4)) AS VARCHAR) AS YearMonth,  
        ((DAY(allPost.Createdtime) - 1) / 7) + 1 AS WeekNumber,  
        allPost.deptname,  
        allPost.postname,  
        allPost.location,  
        FORMAT(allPost.Createdtime, 'dd-MM-yyyy') AS Createdtime,  
       (SELECT STUFF((SELECT DISTINCT ', ' + candi.CandidatesName  
                       FROM tbl_Tracker_InterviewTaken_Details candi  
                       WHERE candi.Plmapid = allPost.plmapid  
                       FOR XML PATH('')), 1, 2, '')) AS CandidatesName,  
  
  (SELECT STUFF((SELECT DISTINCT ', ' + emp.empfirstname + ' ' + emp.empmiddlename + ' ' + emp.emplastname  
               FROM tbl_Tracker_InterviewTaken_Details candi  
               INNER JOIN essp.dbo.Empbasic emp ON emp.empno = candi.InterviewTakenId  
               WHERE candi.Plmapid = allPost.plmapid  
               FOR XML PATH('')), 1, 2, '')) AS InterviewerName,  
   --      FROM tbl_Tracker_InterviewTaken_Details candi  
   --      WHERE candi.Plmapid = allPost.plmapid) AS CandidatesName  
  
  -------------------------Status Display--------------------------------------  
     candi.CandidatesPsychometryReport,  
   candi.CandidateBackgroundVerificationReport,  
   candi.ChallengesName,  
   candi.Remarks,  
   candi.CandidateStatus,  
 ------------------------------------  
 ----------Active or not Status----------  
 allPost.status
 --, 1 RowStatus
     ------------------------------- 
  FROM   
        vw_Recruitment_AllPost allPost  
  left join tbl_Tracker_InterviewTaken_Details as candi  
  on candi.Plmapid=allPost.plmapid  
--   where ( 
--  -- allPost.DeptId = Case When @DeptId =null THen  allpost.DeptId End 
--  --and allPost.DeptId IN (SELECT Name FROM dbo.splitstring(@DeptId),

--  --Only for dept
--@DeptId IS NOT NULL and allPost.DeptId IN (SELECT Name FROM dbo.splitstring(@DeptId))
--) or (
----- Only for Dept and Post
--(@DeptId is not null and @PostId is not null and allPost.DeptId in(Select name from dbo.splitstring(@Deptid)) and allPost.postid in(select name from dbo.splitstring(@PostId))
--) or(
---- Only for Dept and Post and Location
--@DeptId is not null and @PostId is not null and @LocationId is not null and allPost.DeptId in(Select name from dbo.splitstring(@DeptId)) and allPost.postid in(select name from dbo.splitstring(@PostId)) and allPost.locid in (Select name from dbo.splitstring(@LocationId))
--) or (
---- Only Date
--@Date is not null and (LEFT(DATENAME(MONTH, CONVERT(DATETIME, allPost.Createdtime, 103)), 3) +'-' + CAST(YEAR(CONVERT(DATETIME, allPost.Createdtime, 103)) AS VARCHAR(4))) = @Date  
----(LEFT(DATENAME(MONTH, CONVERT(DATETIME, allPost.Createdtime, 103)), 3) + '-' + CAST(YEAR(CONVERT(DATETIME, allPost.Createdtime, 103)) AS VARCHAR(4))) = @Date
--)or(
----Only for Date and Week
--@Date is not null and @Week is not null and (LEFT(DATENAME(MONTH, CONVERT(DATETIME, allPost.Createdtime, 103)), 3) + '-' + CAST(YEAR(CONVERT(DATETIME, allPost.Createdtime, 103)) AS VARCHAR(4))) = @Date and ((DAY(CONVERT(DATETIME, candi.CreatedDate, 103)) - 1) / 7) + 1 = @Week 
--)
--or(
----Only Date & Dept
--@Date is not null and @DeptId is not null and allPost.DeptId in(Select name from dbo.splitstring(@Deptid)) and (LEFT(DATENAME(MONTH, CONVERT(DATETIME, allPost.Createdtime, 103)), 3) +'-' + CAST(YEAR(CONVERT(DATETIME, allPost.Createdtime, 103)) AS VARCHAR(4))) = @Date
--)
--or(
----Only for Date & Dept and Post
--@Date is not null and @DeptId is not null and @PostId is not null and allPost.DeptId in(Select name from dbo.splitstring(@Deptid)) and (LEFT(DATENAME(MONTH, CONVERT(DATETIME, allPost.Createdtime, 103)), 3) +'-' + CAST(YEAR(CONVERT(DATETIME, allPost.Createdtime, 103)) AS VARCHAR(4))) = @Date and allPost.postid in(select name from dbo.splitstring(@PostId)) 
--)or( 
----Only for Date and Dept and Post and Location
--@date is not null and @DeptId is not null and @PostId is not null and @LocationId is not null and allPost.DeptId in(Select name from dbo.splitstring(@Deptid)) and (LEFT(DATENAME(MONTH, CONVERT(DATETIME, allPost.Createdtime, 103)), 3) +'-' + CAST(YEAR(CONVERT(DATETIME, allPost.Createdtime, 103)) AS VARCHAR(4))) = @Date and allPost.postid in(select name from dbo.splitstring(@PostId)) and allPost.location in(Select name from dbo.splitstring(@LocationId))
--)or(
----Only Date and week and Dept
--@Date is not null and @Week is not null and @DeptId is not null and allPost.DeptId in(Select name from dbo.splitstring(@Deptid)) and (LEFT(DATENAME(MONTH, CONVERT(DATETIME, allPost.Createdtime, 103)), 3) +'-' + CAST(YEAR(CONVERT(DATETIME, allPost.Createdtime, 103)) AS VARCHAR(4))) = @Date and ((DAY(CONVERT(DATETIME, candi.CreatedDate, 103)) - 1) / 7) + 1 = @Week
--)or(
----Only Date and Week and Dept and Post
--@Date is not null and @Week is not null and @DeptId is not null and @PostId is not null and allPost.DeptId in(Select name from dbo.splitstring(@Deptid)) and (LEFT(DATENAME(MONTH, CONVERT(DATETIME, allPost.Createdtime, 103)), 3) +'-' + CAST(YEAR(CONVERT(DATETIME, allPost.Createdtime, 103)) AS VARCHAR(4))) = @Date and ((DAY(CONVERT(DATETIME, candi.CreatedDate, 103)) - 1) / 7) + 1 = @Week and allPost.postid in(select name from dbo.splitstring(@PostId))
--)or (
----only Date and Week and Dept and post and Location
--@Date is not null and @Week is not null and @DeptId is not null and @PostId is not null and @LocationId is not null and allPost.DeptId in(Select name from dbo.splitstring(@Deptid)) and (LEFT(DATENAME(MONTH, CONVERT(DATETIME, allPost.Createdtime, 103)), 3) +'-' + CAST(YEAR(CONVERT(DATETIME, allPost.Createdtime, 103)) AS VARCHAR(4))) = @Date and ((DAY(CONVERT(DATETIME, candi.CreatedDate, 103)) - 1) / 7) + 1 = @Week and allPost.postid in(select name from dbo.splitstring(@PostId)) and allPost.location in(Select name from dbo.splitstring(@LocationId))
--)--or (
------Default page load
------@Date is not null and @Week is not null and @DeptId is not null and @PostId is not null and @LocationId is not null and 
----allPost.Createdtime <= GETDATE()
----)
--)
------------------------------------------------------------
--Where  A.IDCandidate = Case When @IDCan =0 THen  A.IDCandidate End 
--And	A.IDCandidate = Case When @IDCan =0 THen  A.IDCandidate End
------------------------------------------------------------
where( (LEFT(DATENAME(MONTH, CONVERT(DATETIME, allPost.Createdtime, 103)), 3) +'-' + CAST(YEAR(CONVERT(DATETIME, allPost.Createdtime, 103)) AS VARCHAR(4))) = Case when @Date=0 then allPost.Createdtime end )
--and allPost.Createdtime =case when @Date=0 then allPost.Createdtime end ) 

end


--select * from vw_Recruitment_AllPost order by Createdtime desc
GO

/* Functional group: 08_INTERVIEW; referenced grouped tables: tbl_Tracker_InterviewTaken_Details */
/****** Object:  StoredProcedure [dbo].[RecruitmentTracker_Dummy_Temp]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- RecruitmentTracker_Dummy_Temp
CREATE PROCEDURE [dbo].[RecruitmentTracker_Dummy_Temp]  
    @Date VARCHAR(MAX) = NULL,  
    @Week VARCHAR(MAX) = NULL,  
    @DeptId VARCHAR(MAX) = NULL,  
    @PostId VARCHAR(MAX) = NULL,  
    @LocationId VARCHAR(MAX) = NULL  
AS  
BEGIN  
  --Only Interview
   
      DECLARE @Month INT, @Year INT, @FirstDayOfMonth DATE, @FirstDayOfWeek DATE, @LastDayOfWeek DATE;  
  
    DECLARE @MonthName VARCHAR(3) = LEFT(@Date, CHARINDEX('-', @Date) - 1);    
    DECLARE @YearSuffix VARCHAR(2) = RIGHT(@Date, 2);  
    SET @Month = MONTH(CAST('01-' + @MonthName + '-2000' AS DATETIME));  
    SET @Year = 2000 + CAST(@YearSuffix AS INT);  
  
    SET @FirstDayOfMonth = DATEFROMPARTS(@Year, @Month, 1);  
  
    DECLARE @WeekInt INT = CAST(@Week AS INT);  
    SET @FirstDayOfWeek = DATEADD(WEEK, @WeekInt - 1, @FirstDayOfMonth);  
    SET @LastDayOfWeek = DATEADD(DAY, 6 - DATEPART(WEEKDAY, @FirstDayOfWeek) + 1, @FirstDayOfWeek);  
  
    DECLARE @LastDayOfMonth DATE = EOMONTH(@FirstDayOfMonth);  
    IF @LastDayOfWeek > @LastDayOfMonth  
    BEGIN  
        SET @LastDayOfWeek = @LastDayOfMonth;  
    END  
  
   -- SELECT @LastDayOfWeek AS LastDayOfWeek  
	Select	M.*
	FRom (
    SELECT  
        allPost.plmapid,  
      CAST(LEFT(DATENAME(MONTH, CONVERT(DATETIME, candi.CreatedDate, 103)), 3) + '-' + CAST(YEAR(CONVERT(DATETIME, candi.CreatedDate, 103)) AS VARCHAR(4)) AS VARCHAR) AS YearMonth,  
        ((DAY(candi.CreatedDate) - 1) / 7) + 1 AS WeekNumber,  
        allPost.deptname,  
        allPost.postname,  
        allPost.location,  
        FORMAT(allPost.Createdtime, 'dd-MM-yyyy') AS Createdtime,  
       (SELECT STUFF((SELECT DISTINCT ', ' + candi.CandidatesName  
                       FROM tbl_Tracker_InterviewTaken_Details candi  
                       WHERE candi.Plmapid = allPost.plmapid  
                       FOR XML PATH('')), 1, 2, '')) AS CandidatesName,  
  
  (SELECT STUFF((SELECT DISTINCT ', ' + emp.empfirstname + ' ' + emp.empmiddlename + ' ' + emp.emplastname  
               FROM tbl_Tracker_InterviewTaken_Details candi  
               INNER JOIN essp.dbo.Empbasic emp ON emp.empno = candi.InterviewTakenId  
               WHERE candi.Plmapid = allPost.plmapid  
               FOR XML PATH('')), 1, 2, '')) AS InterviewerName,  
   --      FROM tbl_Tracker_InterviewTaken_Details candi  
   --      WHERE candi.Plmapid = allPost.plmapid) AS CandidatesName  
  
  -------------------------Status Display--------------------------------------  
     candi.CandidatesPsychometryReport,  
   candi.CandidateBackgroundVerificationReport,  
   candi.ChallengesName,  
   candi.Remarks,  
   candi.CandidateStatus,  
 ------------------------------------  
 ----------Active or not Status----------  
 allPost.status, 1 RowStatus
     ------------------------------- 
  FROM   
        vw_Recruitment_AllPost allPost  
  Inner join tbl_Tracker_InterviewTaken_Details as candi  
  on candi.Plmapid=allPost.plmapid  
   
 WHERE  
        1 = CASE   
  -- Only For Dept  
  
                WHEN @DeptId IS NOT NULL AND @PostId IS NULL AND @LocationId IS NULL and @Date is null and @Week is null THEN   
  CASE WHEN allPost.DeptId IN (SELECT Name FROM dbo.splitstring(@DeptId)) THEN 1 ELSE 0 END  
         --For Dept and Post  
      WHEN @DeptId IS NOT NULL AND @PostId IS NOT NULL AND @LocationId IS NULL and @Date is null and @Week is null THEN   
                    CASE WHEN allPost.DeptId IN (SELECT Name FROM dbo.splitstring(@DeptId))   
                             AND allPost.PostId IN (SELECT Name FROM dbo.splitstring(@PostId))   
                        THEN 1 ELSE 0 END  
  -- For Dept & Post & Location  
                WHEN @DeptId IS NOT NULL AND @PostId IS NOT NULL AND @LocationId IS NOT NULL and @Date is null and @Week is null THEN   
                    CASE WHEN allPost.DeptId IN (SELECT Name FROM dbo.splitstring(@DeptId))   
                             AND allPost.PostId IN (SELECT Name FROM dbo.splitstring(@PostId))   
                             AND allPost.locid IN (SELECT Name FROM dbo.splitstring(@LocationId))  
                        THEN 1 ELSE 0 END  
  
      -- For Date         
       WHEN @Date IS NOT NULL AND @Week IS NULL AND @DeptId IS NULL AND @PostId IS NULL AND @LocationId IS NULL THEN  
     CASE WHEN (LEFT(DATENAME(MONTH, CONVERT(DATETIME, candi.CreatedDate, 103)), 3) + '-' +   
             CAST(YEAR(CONVERT(DATETIME, candi.CreatedDate, 103)) AS VARCHAR(4))) = @Date                      
           THEN  1   
     ELSE 0  
     end  
  
-----------------------------when pass Only Date then show all record upto current month---------------------------  
   --WHEN @Date IS NOT NULL AND @Week IS NULL AND @DeptId IS NULL AND @PostId IS NULL AND @LocationId IS NULL THEN  
   --  CASE   WHEN CONVERT(DATETIME, allPost.Createdtime, 103) <= EOMONTH(CONVERT(DATETIME, '01-' + @Date, 105))  
   --       --  AND   CONVERT(DATETIME, candi.CreatedDate, 103) <= EOMONTH(CONVERT(DATETIME, '01-' + @Date, 105))   
   --  THEN 1  
   -- ELSE 0   
   --END  
  
-------------------------------------------------------------------------------------------------  
  
  -- For Date & Week  
     WHEN @Date IS NOT NULL AND @Week IS NOT NULL AND @DeptId IS NULL AND @PostId IS NULL AND @LocationId IS NULL THEN   
                    CASE WHEN (LEFT(DATENAME(MONTH, CONVERT(DATETIME, candi.CreatedDate, 103)), 3) +'-' + CAST(YEAR(CONVERT(DATETIME, candi.CreatedDate, 103)) AS VARCHAR(4))) = @Date  
                             AND ((DAY(CONVERT(DATETIME, candi.CreatedDate, 103)) - 1) / 7) + 1 = @Week  
                        THEN 1 ELSE 0   
      END  
 ---------------------------------------------------------------------------------------------------------  
   -- For Date & Week & Dept  
    WHEN @Date IS NOT NULL AND @Week IS NOT NULL AND @DeptId IS not NULL AND @PostId IS NULL AND @LocationId IS NULL THEN   
               CASE WHEN (LEFT(DATENAME(MONTH, CONVERT(DATETIME, candi.CreatedDate, 103)), 3) +'-' + CAST(YEAR(CONVERT(DATETIME, candi.CreatedDate, 103)) AS VARCHAR(4))) = @Date  
       -- CASE WHEN CONVERT(DATETIME, allPost.Createdtime, 103) <= EOMONTH(CONVERT(DATETIME, '01-' +@Date, 105))  
         --AND   CONVERT(DATETIME, candi.CreatedDate, 103) <= EOMONTH(CONVERT(DATETIME, '01-' + @Date, 105))  
                             AND ((DAY(CONVERT(DATETIME, candi.CreatedDate, 103)) - 1) / 7) + 1 = @Week  
      --  AND (CONVERT(DATETIME, allPost.Createdtime, 103) <= @LastDayOfWeek)  
        and allPost.DeptId IN(SELECT Name FROM dbo.splitstring(@DeptId))  
                        THEN 1 ELSE 0 END  
  
  
     -- For Date & Dept  
      WHEN @Date IS NOT NULL AND @Week IS NULL AND @DeptId IS not NULL AND @PostId IS NULL AND @LocationId IS NULL THEN   
     CASE  
       WHEN (LEFT(DATENAME(MONTH, CONVERT(DATETIME, candi.CreatedDate, 103)), 3) +'-' + CAST(YEAR(CONVERT(DATETIME, candi.CreatedDate, 103)) AS VARCHAR(4))) = @Date  
      --   WHEN CONVERT(DATETIME, allPost.Createdtime, 103) <= EOMONTH(CONVERT(DATETIME, '01-' +@Date, 105))  
        and allPost.DeptId IN (SELECT Name FROM dbo.splitstring(@DeptId))  
                        THEN 1 ELSE 0 END  
  
      ---date dept and post  
       WHEN @Date IS NOT NULL AND @Week IS NULL AND @DeptId IS not NULL AND @PostId IS not null AND @LocationId IS NULL THEN   
        CASE WHEN (LEFT(DATENAME(MONTH, CONVERT(DATETIME, candi.CreatedDate, 103)), 3) +'-' + CAST(YEAR(CONVERT(DATETIME, candi.CreatedDate, 103)) AS VARCHAR(4))) = @Date  
       --  CASE WHEN CONVERT(DATETIME, allPost.Createdtime, 103) <= EOMONTH(CONVERT(DATETIME, '01-' +@Date, 105))  
          -- AND   CONVERT(DATETIME, candi.CreatedDate, 103) <= EOMONTH(CONVERT(DATETIME, '01-' + @Date, 105))  
        and allPost.DeptId IN (SELECT Name FROM dbo.splitstring(@DeptId))  
        AND allPost.PostId IN (SELECT Name FROM dbo.splitstring(@PostId))  
                        THEN 1 ELSE 0 END  
  
      --date dept and post and location  
       WHEN @Date IS NOT NULL AND @Week IS NULL AND @DeptId IS not NULL AND @PostId IS not null AND @LocationId IS not NULL THEN   
                          CASE WHEN (LEFT(DATENAME(MONTH, CONVERT(DATETIME, candi.CreatedDate, 103)), 3) +'-' + CAST(YEAR(CONVERT(DATETIME, candi.CreatedDate, 103)) AS VARCHAR(4))) = @Date  
       -- CASE WHEN CONVERT(DATETIME, allPost.Createdtime, 103) <= EOMONTH(CONVERT(DATETIME, '01-' +@Date, 105))  
        -- AND   CONVERT(DATETIME, candi.CreatedDate, 103) <= EOMONTH(CONVERT(DATETIME, '01-' + @Date, 105))  
        and allPost.DeptId IN (SELECT Name FROM dbo.splitstring(@DeptId))  
        AND allPost.PostId IN (SELECT Name FROM dbo.splitstring(@PostId))  
         AND allPost.locid IN (SELECT Name FROM dbo.splitstring(@LocationId))  
                        THEN 1 ELSE 0   
     END  
  
      -- For Date & Week & Dept & post  
    WHEN @Date IS NOT NULL AND @Week IS NOT NULL AND @DeptId IS not NULL AND @PostId IS not null AND @LocationId IS NULL THEN   
                     CASE WHEN (LEFT(DATENAME(MONTH, CONVERT(DATETIME, candi.CreatedDate, 103)), 3) +'-' + CAST(YEAR(CONVERT(DATETIME, candi.CreatedDate, 103)) AS VARCHAR(4))) = @Date  
       -- CASE  WHEN CONVERT(DATETIME, allPost.Createdtime, 103) <= EOMONTH(CONVERT(DATETIME, '01-' +@Date, 105))  
        AND ((DAY(CONVERT(DATETIME, candi.CreatedDate, 103)) - 1) / 7) + 1 <= @Week  
       -- AND (CONVERT(DATETIME, allPost.Createdtime, 103) <= @LastDayOfWeek)  
        and allPost.DeptId IN (SELECT Name FROM dbo.splitstring(@DeptId))  
        AND allPost.PostId IN (SELECT Name FROM dbo.splitstring(@PostId))  
                        THEN 1 ELSE 0 END  
  
      -- For Date & week & dept & post & location  
       WHEN @Date IS NOT NULL AND @Week IS NOT NULL AND @DeptId IS not NULL AND @PostId IS not null AND @LocationId IS not NULL THEN   
                    --CASE  WHEN CONVERT(DATETIME, allPost.Createdtime, 103) <= EOMONTH(CONVERT(DATETIME, '01-' +@Date, 105))  
                      CASE WHEN (LEFT(DATENAME(MONTH, CONVERT(DATETIME, candi.CreatedDate, 103)), 3) +'-' + CAST(YEAR(CONVERT(DATETIME, candi.CreatedDate, 103)) AS VARCHAR(4))) = @Date  
        AND ((DAY(CONVERT(DATETIME, candi.CreatedDate, 103)) - 1) / 7) + 1 <= @Week     
      -- AND (CONVERT(DATETIME, allPost.Createdtime, 103) <= @LastDayOfWeek)  
        and allPost.DeptId IN (SELECT Name FROM dbo.splitstring(@DeptId))  
      AND allPost.PostId IN (SELECT Name FROM dbo.splitstring(@PostId))  
         AND allPost.locid IN (SELECT Name FROM dbo.splitstring(@LocationId))  
                        THEN 1 ELSE 0 END  
  
      -- for date & dept & Post & location  
      WHEN @Date IS NOT NULL AND @Week IS NULL AND @DeptId IS not NULL AND @PostId IS not null AND @LocationId IS not NULL THEN   
                    CASE WHEN (LEFT(DATENAME(MONTH, CONVERT(DATETIME, candi.CreatedDate, 103)), 3) +'-' + CAST(YEAR(CONVERT(DATETIME, candi.CreatedDate, 103)) AS VARCHAR(4))) = @Date  
                          -- AND   CONVERT(DATETIME, candi.CreatedDate, 103) <= EOMONTH(CONVERT(DATETIME, '01-' + @Date, 105))  
           and allPost.DeptId IN (SELECT Name FROM dbo.splitstring(@DeptId))  
        AND allPost.PostId IN (SELECT Name FROM dbo.splitstring(@PostId))  
         AND allPost.locid IN (SELECT Name FROM dbo.splitstring(@LocationId))  
                        THEN 1 ELSE 0 END  
  
  
      -- for date & dept & Post & location  
      WHEN @Date IS NOT NULL AND @Week IS NULL AND @DeptId IS not NULL AND @PostId IS not null AND @LocationId IS not NULL THEN   
                    CASE WHEN (LEFT(DATENAME(MONTH, CONVERT(DATETIME, candi.CreatedDate, 103)), 3) +'-' + CAST(YEAR(CONVERT(DATETIME, candi.CreatedDate, 103)) AS VARCHAR(4))) = @Date  
                          -- AND   CONVERT(DATETIME, candi.CreatedDate, 103) <= EOMONTH(CONVERT(DATETIME, '01-' + @Date, 105))      
       and allPost.DeptId IN (SELECT Name FROM dbo.splitstring(@DeptId))  
        AND allPost.PostId IN (SELECT Name FROM dbo.splitstring(@PostId))  
         AND allPost.locid IN (SELECT Name FROM dbo.splitstring(@LocationId))  
                        THEN 1 ELSE 0 END  
  
  
  
      -- For Default orNot select or Page Load  
      WHEN @Date IS NULL AND @Week IS NULL AND @DeptId IS NULL AND @PostId IS null AND @LocationId IS NULL THEN   
  
                    CASE WHEN   
     --allPost.Createdtime >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0) -- First day of current month  
     -- AND allPost.Createdtime < DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) + 1, 0)   
      candi.CreatedDate <=GETDATE()   
                        THEN 1   
  
  
  
    ELSE 0 END  
                ELSE 0  
  
            END  
   GROUP BY  
        allPost.plmapid,  
  --allPost.CandidatesName,  
        allPost.deptname,  
        allPost.postname,  
        allPost.location,  
        allPost.Createdtime,  
   candi.CandidatesPsychometryReport,  
  candi.CandidateBackgroundVerificationReport,  
  candi.ChallengesName,  
   candi.Remarks,  
   candi.CandidateStatus,  
   allPost.status,  
   candi.CreatedDate,  
   candi.CreatedDate


   
	   UNION ALL

		SELECT  
        allPost.plmapid,  
      CAST(LEFT(DATENAME(MONTH, CONVERT(DATETIME, allPost.Createdtime, 103)), 3) + '-' + CAST(YEAR(CONVERT(DATETIME, allPost.Createdtime, 103)) AS VARCHAR(4)) AS VARCHAR) AS YearMonth,  
        ((DAY(allPost.Createdtime) - 1) / 7) + 1 AS WeekNumber,  
        allPost.deptname,  
        allPost.postname,  
        allPost.location,  
        FORMAT(allPost.Createdtime, 'dd-MM-yyyy') AS Createdtime,  
    
  null AS CandidatesName,  
  null as InterviewerName,
  null as CandidatesPsychometryReport,  
  null CandidateBackgroundVerificationReport,  
  null ChallengesName,  
  null Remarks,  
  null CandidateStatus,  
 ------------------------------------  
 ----------Active or not Status----------  
 allPost.status ,2 RowStatus
     -------------------------------  
  FROM   
        vw_Recruitment_AllPost allPost  
 
 WHERE  
        1 = CASE   
  -- Only For Dept  
  
                WHEN @DeptId IS NOT NULL AND @PostId IS NULL AND @LocationId IS NULL and @Date is null and @Week is null THEN   
                    CASE WHEN allPost.DeptId IN (SELECT Name FROM dbo.splitstring(@DeptId)) THEN 1 ELSE 0 END  
         --For Dept and Post  
      WHEN @DeptId IS NOT NULL AND @PostId IS NOT NULL AND @LocationId IS NULL and @Date is null and @Week is null THEN   
                    CASE WHEN allPost.DeptId IN (SELECT Name FROM dbo.splitstring(@DeptId))   
                             AND allPost.PostId IN (SELECT Name FROM dbo.splitstring(@PostId))   
                        THEN 1 ELSE 0 END  
  -- For Dept & Post & Location  
                WHEN @DeptId IS NOT NULL AND @PostId IS NOT NULL AND @LocationId IS NOT NULL and @Date is null and @Week is null THEN   
                    CASE WHEN allPost.DeptId IN (SELECT Name FROM dbo.splitstring(@DeptId))   
                             AND allPost.PostId IN (SELECT Name FROM dbo.splitstring(@PostId))   
                             AND allPost.locid IN (SELECT Name FROM dbo.splitstring(@LocationId))  
                        THEN 1 ELSE 0 END  
  
      -- For Date         
       WHEN @Date IS NOT NULL AND @Week IS NULL AND @DeptId IS NULL AND @PostId IS NULL AND @LocationId IS NULL THEN  
     CASE WHEN (LEFT(DATENAME(MONTH, CONVERT(DATETIME, allPost.Createdtime, 103)), 3) + '-' +   
             CAST(YEAR(CONVERT(DATETIME, allPost.Createdtime, 103)) AS VARCHAR(4))) = @Date                      
           THEN  1   
     ELSE 0  
     end  
  

-------------------------------------------------------------------------------------------------  
  
  -- For Date & Week  
     WHEN @Date IS NOT NULL AND @Week IS NOT NULL AND @DeptId IS NULL AND @PostId IS NULL AND @LocationId IS NULL THEN   
                    CASE WHEN (LEFT(DATENAME(MONTH, CONVERT(DATETIME, allPost.Createdtime, 103)), 3) +'-' + CAST(YEAR(CONVERT(DATETIME, allPost.Createdtime, 103)) AS VARCHAR(4))) = @Date  
                             AND ((DAY(CONVERT(DATETIME, allPost.Createdtime, 103)) - 1) / 7) + 1 = @Week  
                        THEN 1 ELSE 0   
      END  
 ---------------------------------------------------------------------------------------------------------  
   -- For Date & Week & Dept  
    WHEN @Date IS NOT NULL AND @Week IS NOT NULL AND @DeptId IS not NULL AND @PostId IS NULL AND @LocationId IS NULL THEN   
               CASE WHEN (LEFT(DATENAME(MONTH, CONVERT(DATETIME, allPost.Createdtime, 103)), 3) +'-' + CAST(YEAR(CONVERT(DATETIME, allPost.Createdtime, 103)) AS VARCHAR(4))) = @Date  
       -- CASE WHEN CONVERT(DATETIME, allPost.Createdtime, 103) <= EOMONTH(CONVERT(DATETIME, '01-' +@Date, 105))  
         --AND   CONVERT(DATETIME, candi.CreatedDate, 103) <= EOMONTH(CONVERT(DATETIME, '01-' + @Date, 105))  
                             AND ((DAY(CONVERT(DATETIME, allPost.Createdtime, 103)) - 1) / 7) + 1 = @Week  
      --  AND (CONVERT(DATETIME, allPost.Createdtime, 103) <= @LastDayOfWeek)  
        and allPost.DeptId IN(SELECT Name FROM dbo.splitstring(@DeptId))  
                        THEN 1 ELSE 0 END  
  
  
     -- For Date & Dept  
      WHEN @Date IS NOT NULL AND @Week IS NULL AND @DeptId IS not NULL AND @PostId IS NULL AND @LocationId IS NULL THEN   
     CASE  
       WHEN (LEFT(DATENAME(MONTH, CONVERT(DATETIME, allPost.Createdtime, 103)), 3) +'-' + CAST(YEAR(CONVERT(DATETIME, allPost.Createdtime, 103)) AS VARCHAR(4))) = @Date  
      --   WHEN CONVERT(DATETIME, allPost.Createdtime, 103) <= EOMONTH(CONVERT(DATETIME, '01-' +@Date, 105))  
        and allPost.DeptId IN (SELECT Name FROM dbo.splitstring(@DeptId))  
                        THEN 1 ELSE 0 END  
  
      ---date dept and post  
       WHEN @Date IS NOT NULL AND @Week IS NULL AND @DeptId IS not NULL AND @PostId IS not null AND @LocationId IS NULL THEN   
        CASE WHEN (LEFT(DATENAME(MONTH, CONVERT(DATETIME, allPost.Createdtime, 103)), 3) +'-' + CAST(YEAR(CONVERT(DATETIME, allPost.Createdtime, 103)) AS VARCHAR(4))) = @Date  
       --  CASE WHEN CONVERT(DATETIME, allPost.Createdtime, 103) <= EOMONTH(CONVERT(DATETIME, '01-' +@Date, 105))  
          -- AND   CONVERT(DATETIME, candi.CreatedDate, 103) <= EOMONTH(CONVERT(DATETIME, '01-' + @Date, 105))  
        and allPost.DeptId IN (SELECT Name FROM dbo.splitstring(@DeptId))  
        AND allPost.PostId IN (SELECT Name FROM dbo.splitstring(@PostId))  
                        THEN 1 ELSE 0 END  
  
      --date dept and post and location  
       WHEN @Date IS NOT NULL AND @Week IS NULL AND @DeptId IS not NULL AND @PostId IS not null AND @LocationId IS not NULL THEN   
                          CASE WHEN (LEFT(DATENAME(MONTH, CONVERT(DATETIME, allPost.Createdtime, 103)), 3) +'-' + CAST(YEAR(CONVERT(DATETIME, allPost.Createdtime, 103)) AS VARCHAR(4))) = @Date  
       -- CASE WHEN CONVERT(DATETIME, allPost.Createdtime, 103) <= EOMONTH(CONVERT(DATETIME, '01-' +@Date, 105))  
        -- AND   CONVERT(DATETIME, candi.CreatedDate, 103) <= EOMONTH(CONVERT(DATETIME, '01-' + @Date, 105))  
        and allPost.DeptId IN (SELECT Name FROM dbo.splitstring(@DeptId))  
        AND allPost.PostId IN (SELECT Name FROM dbo.splitstring(@PostId))  
         AND allPost.locid IN (SELECT Name FROM dbo.splitstring(@LocationId))  
                        THEN 1 ELSE 0   
     END  
  
      -- For Date & Week & Dept & post  
    WHEN @Date IS NOT NULL AND @Week IS NOT NULL AND @DeptId IS not NULL AND @PostId IS not null AND @LocationId IS NULL THEN   
                     CASE WHEN (LEFT(DATENAME(MONTH, CONVERT(DATETIME, allPost.Createdtime, 103)), 3) +'-' + CAST(YEAR(CONVERT(DATETIME, allPost.Createdtime, 103)) AS VARCHAR(4))) = @Date  
       -- CASE  WHEN CONVERT(DATETIME, allPost.Createdtime, 103) <= EOMONTH(CONVERT(DATETIME, '01-' +@Date, 105))  
        AND ((DAY(CONVERT(DATETIME, allPost.Createdtime, 103)) - 1) / 7) + 1 <= @Week  
       -- AND (CONVERT(DATETIME, allPost.Createdtime, 103) <= @LastDayOfWeek)  
        and allPost.DeptId IN (SELECT Name FROM dbo.splitstring(@DeptId))  
        AND allPost.PostId IN (SELECT Name FROM dbo.splitstring(@PostId))  
                        THEN 1 ELSE 0 END  
  
      -- For Date & week & dept & post & location  
       WHEN @Date IS NOT NULL AND @Week IS NOT NULL AND @DeptId IS not NULL AND @PostId IS not null AND @LocationId IS not NULL THEN   
                    --CASE  WHEN CONVERT(DATETIME, allPost.Createdtime, 103) <= EOMONTH(CONVERT(DATETIME, '01-' +@Date, 105))  
                      CASE WHEN (LEFT(DATENAME(MONTH, CONVERT(DATETIME, allPost.Createdtime, 103)), 3) +'-' + CAST(YEAR(CONVERT(DATETIME, allPost.Createdtime, 103)) AS VARCHAR(4))) = @Date  
        AND ((DAY(CONVERT(DATETIME, allPost.Createdtime, 103)) - 1) / 7) + 1 <= @Week     
      -- AND (CONVERT(DATETIME, allPost.Createdtime, 103) <= @LastDayOfWeek)  
        and allPost.DeptId IN (SELECT Name FROM dbo.splitstring(@DeptId))  
      AND allPost.PostId IN (SELECT Name FROM dbo.splitstring(@PostId))  
         AND allPost.locid IN (SELECT Name FROM dbo.splitstring(@LocationId))  
                        THEN 1 ELSE 0 END  
  
      -- for date & dept & Post & location  
      WHEN @Date IS NOT NULL AND @Week IS NULL AND @DeptId IS not NULL AND @PostId IS not null AND @LocationId IS not NULL THEN   
                    CASE WHEN (LEFT(DATENAME(MONTH, CONVERT(DATETIME, allPost.Createdtime, 103)), 3) +'-' + CAST(YEAR(CONVERT(DATETIME, allPost.Createdtime, 103)) AS VARCHAR(4))) = @Date  
      -- AND   CONVERT(DATETIME, candi.CreatedDate, 103) <= EOMONTH(CONVERT(DATETIME, '01-' + @Date, 105))  
           and allPost.DeptId IN (SELECT Name FROM dbo.splitstring(@DeptId))  
        AND allPost.PostId IN (SELECT Name FROM dbo.splitstring(@PostId))  
         AND allPost.locid IN (SELECT Name FROM dbo.splitstring(@LocationId))  
                        THEN 1 ELSE 0 END  
  
  
      -- for date & dept & Post & location  
      WHEN @Date IS NOT NULL AND @Week IS NULL AND @DeptId IS not NULL AND @PostId IS not null AND @LocationId IS not NULL THEN   
                    CASE WHEN (LEFT(DATENAME(MONTH, CONVERT(DATETIME, allPost.Createdtime, 103)), 3) +'-' + CAST(YEAR(CONVERT(DATETIME, allPost.Createdtime, 103)) AS VARCHAR(4))) = @Date  
                          -- AND   CONVERT(DATETIME, candi.CreatedDate, 103) <= EOMONTH(CONVERT(DATETIME, '01-' + @Date, 105))      
       and allPost.DeptId IN (SELECT Name FROM dbo.splitstring(@DeptId))  
        AND allPost.PostId IN (SELECT Name FROM dbo.splitstring(@PostId))  
         AND allPost.locid IN (SELECT Name FROM dbo.splitstring(@LocationId))  
                        THEN 1 ELSE 0 END  

      -- For Default orNot select or Page Load  
      WHEN @Date IS NULL AND @Week IS NULL AND @DeptId IS NULL AND @PostId IS null AND @LocationId IS NULL THEN   
                    CASE WHEN         
      allPost.Createdtime <=GETDATE()   
                        THEN 1   

    ELSE 0 END  
                ELSE 0  
  
            END  
   GROUP BY  
        allPost.plmapid,  
   
        allPost.deptname,  
        allPost.postname,  
        allPost.location,  
        allPost.Createdtime,  
  
   allPost.status
   ) M 
   ORDER BY M.RowStatus , M.Createdtime

END  



GO





/* ============================================================================
   9. OFFER / APPOINTMENT / ONBOARDING - offer letter, salary, appointment letter and candidate appointment mapping
   TABLE DEFINITIONS
============================================================================ */

/****** Object:  Table [dbo].[tappointmentletterdtlsofmlexpoperation]    Script Date: 15-08-2026 10:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tappointmentletterdtlsofmlexpoperation](
	[appiontmentid] [int] IDENTITY(1,1) NOT NULL,
	[candidateid] [bigint] NOT NULL,
	[appointmentlettertype] [varchar](max) NULL,
	[appiontmentrefno] [nvarchar](max) NULL,
	[offerrefno] [nvarchar](max) NULL,
	[company] [varchar](50) NULL,
	[appiontmentissuedate] [date] NULL,
	[candidatename] [nvarchar](max) NULL,
	[candidateaddress] [nvarchar](max) NULL,
	[appointpostid] [int] NULL,
	[appointdesignationid] [int] NULL,
	[appointdeptid] [int] NULL,
	[probationperiod] [nvarchar](max) NULL,
	[noticeperiod] [nvarchar](max) NULL,
	[subject] [varchar](max) NULL,
	[joiningdate] [date] NULL,
	[postinglocationid] [int] NULL,
	[para1] [nvarchar](max) NULL,
	[para2] [nvarchar](max) NULL,
	[para3] [nvarchar](max) NULL,
	[para4] [nvarchar](max) NULL,
	[para5] [nvarchar](max) NULL,
	[para6] [nvarchar](max) NULL,
	[para7] [nvarchar](max) NULL,
	[para8] [nvarchar](max) NULL,
	[para9] [nvarchar](max) NULL,
	[para10] [nvarchar](max) NULL,
	[para11] [nvarchar](max) NULL,
	[para12] [nvarchar](max) NULL,
	[para13] [nvarchar](max) NULL,
	[undershine] [nvarchar](max) NULL,
	[deleteflag] [varchar](50) NULL,
	[deleteon] [datetime] NULL,
	[deletedby] [nvarchar](max) NULL,
	[appointmentnotificationsent] [varchar](20) NULL,
	[notificationno] [nvarchar](max) NULL,
	[createdon] [datetime] NULL,
	[createdby] [nvarchar](max) NULL,
	[updatedon] [datetime] NULL,
	[updatedby] [nvarchar](max) NULL,
 CONSTRAINT [PK_tappointmentletterdtlsofmlexpoperation] PRIMARY KEY CLUSTERED 
(
	[appiontmentid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO



/****** Object:  Table [dbo].[tappointmentletterdtlsofmlmtfield]    Script Date: 15-08-2026 10:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tappointmentletterdtlsofmlmtfield](
	[appiontmentid] [int] IDENTITY(1,1) NOT NULL,
	[candidateid] [int] NOT NULL,
	[appointmentlettertype] [varchar](max) NULL,
	[appiontmentrefno] [nvarchar](max) NOT NULL,
	[offerrefno] [nvarchar](max) NOT NULL,
	[company] [varchar](10) NULL,
	[appiontmentissuedate] [date] NULL,
	[candidatename] [nvarchar](max) NULL,
	[candidateaddress] [nvarchar](max) NULL,
	[appointdept] [int] NULL,
	[appoitpost] [int] NULL,
	[appointdesignation] [int] NULL,
	[futurepostid] [int] NULL,
	[futuredepartmentid] [int] NULL,
	[futuredesignationid] [int] NULL,
	[subject] [varchar](max) NULL,
	[joiningdate] [date] NULL,
	[fixedstipend] [varchar](50) NULL,
	[trainingallowance] [varchar](50) NULL,
	[conveyanceallowance] [varchar](50) NULL,
	[totalamount] [varchar](50) NULL,
	[trainingperiod] [varchar](100) NULL,
	[probationperiod] [varchar](100) NULL,
	[trainingexpence] [varchar](100) NULL,
	[bagcost] [varchar](100) NULL,
	[visualaidcost] [varchar](100) NULL,
	[stationarycost] [varchar](100) NULL,
	[giftscost] [varchar](100) NULL,
	[hqallowance] [varchar](50) NULL,
	[exstationallowance] [varchar](50) NULL,
	[transitallowance] [varchar](50) NULL,
	[outstationallowance] [varchar](50) NULL,
	[meetingortrainingallowance] [varchar](50) NULL,
	[km0to25expences] [varchar](50) NULL,
	[km26to75expences] [varchar](50) NULL,
	[km76to150expences] [varchar](50) NULL,
	[km151to250expences] [varchar](50) NULL,
	[km251to500expences] [varchar](50) NULL,
	[km500onwardsexpences] [varchar](50) NULL,
	[postinglocationid] [int] NULL,
	[para1] [nvarchar](max) NULL,
	[para2] [nvarchar](max) NULL,
	[para3] [nvarchar](max) NULL,
	[para4] [nvarchar](max) NULL,
	[para5] [nvarchar](max) NULL,
	[para6] [nvarchar](max) NULL,
	[para7] [nvarchar](max) NULL,
	[para8] [nvarchar](max) NULL,
	[para9] [nvarchar](max) NULL,
	[para10] [nvarchar](max) NULL,
	[para11] [nvarchar](max) NULL,
	[para12] [nvarchar](max) NULL,
	[undershine] [nvarchar](max) NULL,
	[deleteflag] [varchar](10) NULL,
	[deleteon] [datetime] NULL,
	[deleteby] [varchar](max) NULL,
	[appointmentnotificationsent] [varchar](20) NULL,
	[notificationno] [nvarchar](max) NULL,
	[createdby] [varchar](max) NULL,
	[createdon] [datetime] NULL,
	[updatedby] [varchar](max) NULL,
	[updatedon] [datetime] NULL,
 CONSTRAINT [PK_tappointmentletterdtlsofmlmt] PRIMARY KEY CLUSTERED 
(
	[appiontmentid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO



/****** Object:  Table [dbo].[tappointmentletterdtlsofmlmtoperation]    Script Date: 15-08-2026 10:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tappointmentletterdtlsofmlmtoperation](
	[appiontmentid] [bigint] IDENTITY(1,1) NOT NULL,
	[candidateid] [int] NOT NULL,
	[appointmentlettertype] [varchar](max) NULL,
	[appiontmentrefno] [nvarchar](max) NULL,
	[offerrefno] [nvarchar](max) NULL,
	[appiontmentissuedate] [date] NULL,
	[candidatename] [nvarchar](max) NULL,
	[candidateaddress] [nvarchar](max) NULL,
	[postid] [int] NULL,
	[departmentid] [int] NULL,
	[futuredesignationid] [int] NULL,
	[futuredeptid] [int] NULL,
	[fixedstipend] [varchar](50) NULL,
	[trainingallowance] [varchar](50) NULL,
	[conveyenceallowance] [varchar](50) NULL,
	[totalamount] [varchar](50) NULL,
	[subject] [varchar](max) NULL,
	[joiningdate] [date] NULL,
	[postinglocationid] [int] NULL,
	[para1] [nvarchar](max) NULL,
	[para2] [nvarchar](max) NULL,
	[para3] [nvarchar](max) NULL,
	[para4] [nvarchar](max) NULL,
	[para5] [nvarchar](max) NULL,
	[para6] [nvarchar](max) NULL,
	[para7] [nvarchar](max) NULL,
	[para8] [nvarchar](max) NULL,
	[para9] [nvarchar](max) NULL,
	[para10] [nvarchar](max) NULL,
	[undershine] [nvarchar](max) NULL,
	[deleteflag] [varchar](50) NULL,
	[deleteon] [datetime] NULL,
	[deleteby] [varchar](max) NULL,
	[appointmentnotificationsent] [varchar](20) NULL,
	[notificationno] [nvarchar](max) NULL,
	[createdby] [nvarchar](max) NULL,
	[createdon] [datetime] NULL,
	[updatedby] [nvarchar](max) NULL,
	[updatedon] [datetime] NULL,
 CONSTRAINT [PK_tappointmentletterdtlsofmlmtoperation] PRIMARY KEY CLUSTERED 
(
	[appiontmentid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO



/****** Object:  Table [dbo].[tappointmentletterdtlsofmpmt]    Script Date: 15-08-2026 10:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tappointmentletterdtlsofmpmt](
	[appiontmentid] [int] IDENTITY(1,1) NOT NULL,
	[candidateid] [int] NOT NULL,
	[appointmentlettertype] [varchar](max) NULL,
	[appiontmentrefno] [nvarchar](max) NOT NULL,
	[offerrefno] [nvarchar](max) NOT NULL,
	[appiontmentissuedate] [date] NULL,
	[candidatename] [nvarchar](max) NULL,
	[candidateaddress] [nvarchar](max) NULL,
	[postid] [int] NULL,
	[departmentid] [int] NULL,
	[futuredesignationid] [int] NULL,
	[futuredeptid] [int] NULL,
	[fixedstipend] [varchar](50) NULL,
	[trainingallowance] [varchar](50) NULL,
	[conveyenceallowance] [varchar](50) NULL,
	[totalamount] [varchar](50) NULL,
	[subject] [varchar](max) NULL,
	[joiningdate] [date] NULL,
	[postinglocationid] [int] NULL,
	[para1] [nvarchar](max) NULL,
	[para2] [nvarchar](max) NULL,
	[para3] [nvarchar](max) NULL,
	[para4] [nvarchar](max) NULL,
	[para5] [nvarchar](max) NULL,
	[para6] [nvarchar](max) NULL,
	[para7] [nvarchar](max) NULL,
	[para8] [nvarchar](max) NULL,
	[para9] [nvarchar](max) NULL,
	[para10] [nvarchar](max) NULL,
	[undershine] [nvarchar](max) NULL,
	[deleteflag] [varchar](10) NULL,
	[deleteon] [datetime] NULL,
	[deleteby] [varchar](max) NULL,
	[appointmentnotificationsent] [varchar](20) NULL,
	[notificationno] [nvarchar](max) NULL,
	[createdby] [varchar](max) NULL,
	[createdon] [datetime] NULL,
	[updatedby] [varchar](max) NULL,
	[updatedon] [datetime] NULL,
 CONSTRAINT [PK_tappointmentletterdtls] PRIMARY KEY CLUSTERED 
(
	[appiontmentid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO



/****** Object:  Table [dbo].[tappointmentletterdtlsofmpmtfield]    Script Date: 15-08-2026 10:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tappointmentletterdtlsofmpmtfield](
	[appiontmentid] [int] IDENTITY(1,1) NOT NULL,
	[candidateid] [int] NOT NULL,
	[appointmentlettertype] [varchar](max) NULL,
	[appiontmentrefno] [nvarchar](max) NOT NULL,
	[offerrefno] [nvarchar](max) NOT NULL,
	[company] [varchar](10) NULL,
	[appiontmentissuedate] [date] NULL,
	[candidatename] [nvarchar](max) NULL,
	[candidateaddress] [nvarchar](max) NULL,
	[appointdept] [int] NULL,
	[appoitpost] [int] NULL,
	[appointdesignation] [int] NULL,
	[futurepostid] [int] NULL,
	[futuredepartmentid] [int] NULL,
	[futuredesignationid] [int] NULL,
	[subject] [varchar](max) NULL,
	[joiningdate] [date] NULL,
	[fixedstipend] [varchar](50) NULL,
	[trainingallowance] [varchar](50) NULL,
	[conveyanceallowance] [varchar](50) NULL,
	[totalamount] [varchar](50) NULL,
	[trainingperiod] [varchar](100) NULL,
	[probationperiod] [varchar](100) NULL,
	[trainingexpence] [varchar](100) NULL,
	[bagcost] [varchar](100) NULL,
	[visualaidcost] [varchar](100) NULL,
	[stationarycost] [varchar](100) NULL,
	[giftscost] [varchar](100) NULL,
	[hqallowance] [varchar](50) NULL,
	[exstationallowance] [varchar](50) NULL,
	[transitallowance] [varchar](50) NULL,
	[outstationallowance] [varchar](50) NULL,
	[meetingortrainingallowance] [varchar](50) NULL,
	[km0to25expences] [varchar](50) NULL,
	[km26to75expences] [varchar](50) NULL,
	[km76to150expences] [varchar](50) NULL,
	[km151to250expences] [varchar](50) NULL,
	[km251to500expences] [varchar](50) NULL,
	[km500onwardsexpences] [varchar](50) NULL,
	[postinglocationid] [int] NULL,
	[para1] [nvarchar](max) NULL,
	[para2] [nvarchar](max) NULL,
	[para3] [nvarchar](max) NULL,
	[para4] [nvarchar](max) NULL,
	[para5] [nvarchar](max) NULL,
	[para6] [nvarchar](max) NULL,
	[para7] [nvarchar](max) NULL,
	[para8] [nvarchar](max) NULL,
	[para9] [nvarchar](max) NULL,
	[para10] [nvarchar](max) NULL,
	[para11] [nvarchar](max) NULL,
	[para12] [nvarchar](max) NULL,
	[undershine] [nvarchar](max) NULL,
	[deleteflag] [varchar](10) NULL,
	[deleteon] [datetime] NULL,
	[deleteby] [varchar](max) NULL,
	[appointmentnotificationsent] [varchar](20) NULL,
	[notificationno] [nvarchar](max) NULL,
	[createdby] [varchar](max) NULL,
	[createdon] [datetime] NULL,
	[updatedby] [varchar](max) NULL,
	[updatedon] [datetime] NULL,
 CONSTRAINT [PK_tappointmentletterdtlsofmpmtfield] PRIMARY KEY CLUSTERED 
(
	[appiontmentid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO



/****** Object:  Table [dbo].[tappointmentletterformlexpfield]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tappointmentletterformlexpfield](
	[appiontmentid] [int] IDENTITY(1,1) NOT NULL,
	[candidateid] [int] NOT NULL,
	[appointmentlettertype] [varchar](max) NOT NULL,
	[appiontmentrefno] [nvarchar](max) NULL,
	[offerrefno] [nvarchar](max) NULL,
	[company] [varchar](10) NULL,
	[appiontmentissuedate] [date] NULL,
	[candidatename] [nvarchar](max) NULL,
	[candidateaddress] [nvarchar](max) NULL,
	[appointpostid] [int] NULL,
	[appointdesignationid] [int] NULL,
	[appointdeptid] [int] NULL,
	[joiningdate] [date] NULL,
	[subject] [varchar](max) NULL,
	[postinglocationid] [int] NULL,
	[hqallowance] [varchar](50) NULL,
	[exstationallowance] [varchar](50) NULL,
	[transitallowance] [varchar](50) NULL,
	[outstationallowance] [varchar](50) NULL,
	[meetingortrainingallowance] [varchar](50) NULL,
	[km0to25expences] [varchar](50) NULL,
	[km26to75expences] [varchar](50) NULL,
	[km76to150expences] [varchar](50) NULL,
	[km151to250expences] [varchar](50) NULL,
	[km251to500expences] [varchar](50) NULL,
	[km500onwardsexpences] [varchar](50) NULL,
	[para1] [nvarchar](max) NULL,
	[para2] [nvarchar](max) NULL,
	[para3] [nvarchar](max) NULL,
	[para4] [nvarchar](max) NULL,
	[para5] [nvarchar](max) NULL,
	[para6] [nvarchar](max) NULL,
	[para7] [nvarchar](max) NULL,
	[para8] [nvarchar](max) NULL,
	[para9] [nvarchar](max) NULL,
	[para10] [nvarchar](max) NULL,
	[para11] [nvarchar](max) NULL,
	[para12] [nvarchar](max) NULL,
	[para13] [nvarchar](max) NULL,
	[noticeperiod] [varchar](100) NULL,
	[undershine] [nvarchar](max) NULL,
	[deleteflag] [varchar](50) NOT NULL,
	[deleteon] [date] NULL,
	[deletedby] [nvarchar](max) NULL,
	[appointmentnotificationsent] [varchar](20) NULL,
	[notificationno] [nvarchar](max) NULL,
	[createdon] [date] NULL,
	[createdby] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO



/****** Object:  Table [dbo].[tappointmentletterformpexp]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tappointmentletterformpexp](
	[appiontmentid] [int] IDENTITY(1,1) NOT NULL,
	[candidateid] [int] NOT NULL,
	[appointmentlettertype] [varchar](max) NULL,
	[appiontmentrefno] [nvarchar](max) NULL,
	[offerrefno] [nvarchar](max) NULL,
	[company] [varchar](50) NULL,
	[appiontmentissuedate] [date] NULL,
	[candidatename] [nvarchar](max) NULL,
	[candidateaddress] [nvarchar](max) NULL,
	[appointpostid] [int] NULL,
	[appointdesignationid] [int] NULL,
	[appointdeptid] [int] NULL,
	[probationperiod] [nvarchar](max) NULL,
	[noticeperiod] [nvarchar](max) NULL,
	[subject] [varchar](max) NULL,
	[joiningdate] [date] NULL,
	[postinglocationid] [int] NULL,
	[para1] [nvarchar](max) NULL,
	[para2] [nvarchar](max) NULL,
	[para3] [nvarchar](max) NULL,
	[para4] [nvarchar](max) NULL,
	[para5] [nvarchar](max) NULL,
	[para6] [nvarchar](max) NULL,
	[para7] [nvarchar](max) NULL,
	[para8] [nvarchar](max) NULL,
	[para9] [nvarchar](max) NULL,
	[para10] [nvarchar](max) NULL,
	[para11] [nvarchar](max) NULL,
	[para12] [nvarchar](max) NULL,
	[para13] [nvarchar](max) NULL,
	[undershine] [nvarchar](max) NULL,
	[deleteflag] [varchar](50) NULL,
	[deletedon] [datetime] NULL,
	[deletedby] [varchar](max) NULL,
	[appointmentnotificationsent] [varchar](20) NULL,
	[notificationno] [nvarchar](max) NULL,
	[createdon] [datetime] NULL,
	[createdby] [varchar](max) NULL,
	[updatedon] [datetime] NULL,
	[updatedby] [varchar](max) NULL,
 CONSTRAINT [PK_tappointmentletterformpexp] PRIMARY KEY CLUSTERED 
(
	[appiontmentid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO



/****** Object:  Table [dbo].[tappointmentletterformpexpfield]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tappointmentletterformpexpfield](
	[appiontmentid] [int] IDENTITY(1,1) NOT NULL,
	[candidateid] [int] NOT NULL,
	[appointmentlettertype] [varchar](max) NOT NULL,
	[appiontmentrefno] [nvarchar](max) NULL,
	[offerrefno] [nvarchar](max) NULL,
	[company] [varchar](10) NULL,
	[appiontmentissuedate] [date] NULL,
	[candidatename] [nvarchar](max) NULL,
	[candidateaddress] [nvarchar](max) NULL,
	[appointpostid] [int] NULL,
	[appointdesignationid] [int] NULL,
	[appointdeptid] [int] NULL,
	[joiningdate] [date] NULL,
	[subject] [varchar](max) NULL,
	[postinglocationid] [int] NULL,
	[hqallowance] [varchar](50) NULL,
	[exstationallowance] [varchar](50) NULL,
	[transitallowance] [varchar](50) NULL,
	[outstationallowance] [varchar](50) NULL,
	[meetingortrainingallowance] [varchar](50) NULL,
	[km0to25expences] [varchar](50) NULL,
	[km26to75expences] [varchar](50) NULL,
	[km76to150expences] [varchar](50) NULL,
	[km151to250expences] [varchar](50) NULL,
	[km251to500expences] [varchar](50) NULL,
	[km500onwardsexpences] [varchar](50) NULL,
	[para1] [nvarchar](max) NULL,
	[para2] [nvarchar](max) NULL,
	[para3] [nvarchar](max) NULL,
	[para4] [nvarchar](max) NULL,
	[para5] [nvarchar](max) NULL,
	[para6] [nvarchar](max) NULL,
	[para7] [nvarchar](max) NULL,
	[para8] [nvarchar](max) NULL,
	[para9] [nvarchar](max) NULL,
	[para10] [nvarchar](max) NULL,
	[para11] [nvarchar](max) NULL,
	[para12] [nvarchar](max) NULL,
	[para13] [nvarchar](max) NULL,
	[noticeperiod] [varchar](100) NULL,
	[undershine] [nvarchar](max) NULL,
	[deleteflag] [varchar](50) NOT NULL,
	[deleteon] [date] NULL,
	[deletedby] [nvarchar](max) NULL,
	[appointmentnotificationsent] [varchar](20) NULL,
	[notificationno] [nvarchar](max) NULL,
	[createdon] [date] NULL,
	[createdby] [nvarchar](max) NULL,
 CONSTRAINT [PK_tappointmentletterformpexpfield] PRIMARY KEY CLUSTERED 
(
	[appiontmentid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO



/****** Object:  Table [dbo].[tcandidateappointmentmapping]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tcandidateappointmentmapping](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[candidateid] [int] NOT NULL,
	[appointmentlettertype] [varchar](max) NOT NULL,
	[deleteflag] [varchar](50) NOT NULL,
	[empno] [int] NULL,
	[SyncYN] [varchar](1) NULL,
	[IsMigratedEsspSaas] [int] NULL,
	[TenantID] [nvarchar](max) NULL,
 CONSTRAINT [PK_tcandidateappointmentmapping] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO



/****** Object:  Table [dbo].[tofferlatterdtls]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tofferlatterdtls](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[candidateid] [int] NULL,
	[candidatetype] [varchar](50) NULL,
	[offerrefno] [nvarchar](max) NULL,
	[candidatename] [varchar](max) NULL,
	[candidateaddress] [nvarchar](max) NULL,
	[offerissueddate] [varchar](max) NULL,
	[subject] [varchar](max) NULL,
	[postinglocationid] [int] NULL,
	[paraone] [nvarchar](max) NULL,
	[paratwo] [nvarchar](max) NULL,
	[parathree] [nvarchar](max) NULL,
	[parafour] [nvarchar](max) NULL,
	[parafive] [nvarchar](max) NULL,
	[stipend] [varchar](50) NULL,
	[trainingallowance] [varchar](50) NULL,
	[conveyanceallowance] [varchar](50) NULL,
	[undersign] [nvarchar](max) NULL,
	[offerdcompanyname] [varchar](max) NULL,
	[offerdcompanycode] [varchar](50) NULL,
	[joiningdate] [varchar](max) NULL,
	[offerexpirydate] [varchar](max) NULL,
	[previousjoingdate] [varchar](max) NULL,
	[joinextensionreason] [varchar](max) NULL,
	[joiningextensionby] [varchar](max) NULL,
	[joiningextensionon] [datetime] NULL,
	[offernotificationsent] [varchar](50) NULL,
	[notificationno] [nvarchar](max) NULL,
	[acceptancestatus] [varchar](100) NULL,
	[acceptancestatuschangeon] [datetime] NULL,
	[isexpired] [varchar](50) NULL,
	[expiredreason] [varchar](max) NULL,
	[deleteflag] [varchar](50) NULL,
	[deletereason] [varchar](max) NULL,
	[deletedby] [varchar](max) NULL,
	[deleteon] [datetime] NULL,
	[isappiontmentissued] [varchar](100) NULL,
	[appiontmentissuedate] [datetime] NULL,
	[createdby] [varchar](max) NULL,
	[createdon] [datetime] NULL,
	[canfirstname] [varchar](max) NULL,
	[ESIC] [int] NULL,
	[canpin] [varchar](max) NULL,
	[LetterFilePath] [nvarchar](max) NULL,
	[LetterFileName] [nvarchar](max) NULL,
	[ContentType] [nvarchar](200) NULL,
	[FileBinary] [varbinary](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO



/****** Object:  Table [dbo].[tsalaryofappointmenttime]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tsalaryofappointmenttime](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[candidateid] [int] NOT NULL,
	[salaryhead] [varchar](200) NOT NULL,
	[amount] [varchar](100) NOT NULL
) ON [PRIMARY]
GO



/****** Object:  Table [dbo].[tsalaryofoffertime]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tsalaryofoffertime](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[candidateid] [bigint] NOT NULL,
	[salaryhead] [varchar](200) NOT NULL,
	[amount] [varchar](100) NOT NULL
) ON [PRIMARY]
GO




/* ----------------------------------------------------------------------------
   9. OFFER / APPOINTMENT / ONBOARDING - offer letter, salary, appointment letter and candidate appointment mapping
   STORED PROCEDURES
---------------------------------------------------------------------------- */

/* ---- PRIMARY / NON-TEMP PROCEDURES ---- */
