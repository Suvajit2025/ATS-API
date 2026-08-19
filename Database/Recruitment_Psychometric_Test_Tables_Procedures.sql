/*
================================================================================
 RECRUITMENT PSYCHOMETRIC / TEST TABLES AND STORED PROCEDURES
 Source: Database/Recruitment_Functional_Separation_All_Tables_Procedures.sql
 Generated: 2026-08-18

 Contents are extracted as complete object blocks from the functional separation script.
 Review dependencies and CREATE vs ALTER strategy before running in production.
 Tables extracted: 57
 Table ALTER/DEFAULT blocks extracted: 0
 Stored procedure blocks extracted: 72
================================================================================
*/
USE [Recruitment]
GO

/* ========================== TABLES ========================== */
/****** Object:  Table [dbo].[TBL_MLQ_ansmarks]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBL_MLQ_ansmarks](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[questionno] [int] NULL,
	[answerno] [int] NULL,
	[answer] [nvarchar](max) NULL,
	[marks] [int] NULL,
	[languageid] [int] NULL,
 CONSTRAINT [PK_TBL_MLQ_ansmarks] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[TBL_MLQ_candidatelanguagemap]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBL_MLQ_candidatelanguagemap](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[CandidateID] [bigint] NOT NULL,
	[languageid] [int] NOT NULL
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[TBL_MLQ_empdtls]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBL_MLQ_empdtls](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[CandidateID] [bigint] NULL,
	[languageid] [int] NULL,
	[exquesset] [int] NULL,
	[Serialno] [int] NULL,
	[questionid] [int] NULL,
	[answer] [int] NULL,
	[noofattemp] [int] NULL,
	[createdon] [datetime] NULL,
	[updatedon] [datetime] NULL,
	[empattemexam] [int] NULL,
	[quesfinalsubmitques] [varchar](10) NULL
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[TBL_MLQ_examdtls]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBL_MLQ_examdtls](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[CandidateID] [bigint] NULL,
	[languageid] [int] NULL,
	[totalques] [int] NULL,
	[attemques] [int] NULL,
	[finalsubmit] [varchar](10) NULL,
	[attemexam] [int] NULL,
	[Comment] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[TBL_MLQ_quesdtls]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBL_MLQ_quesdtls](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[languageid] [int] NULL,
	[Queslanset] [int] NULL,
	[Ranquesserialno] [int] NULL,
	[quesserialno] [int] NULL,
	[question] [nvarchar](max) NULL,
	[eqquestypeid] [int] NULL,
	[activeflag] [varchar](10) NULL,
	[createdby] [varchar](200) NULL,
	[createdon] [datetime] NULL,
	[upadtedby] [varchar](200) NULL,
	[updatedon] [datetime] NULL,
 CONSTRAINT [PK_TBL_MLQ_quesdtls] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[tdiscrolscoremappingChameleon]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tdiscrolscoremappingChameleon](
	[score] [float] NULL,
	[scoreinmap] [float] NULL
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[tdiscrolscoremappingEagle]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tdiscrolscoremappingEagle](
	[score] [float] NULL,
	[scoreinmap] [float] NULL
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[tdiscrolscoremappingSalmon]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tdiscrolscoremappingSalmon](
	[score] [float] NULL,
	[scoreinmap] [float] NULL
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[tdiscrolscoremappingTiger]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tdiscrolscoremappingTiger](
	[score] [int] NOT NULL,
	[scoreinmap] [float] NOT NULL,
 CONSTRAINT [PK_tdiscrolscoremapping] PRIMARY KEY CLUSTERED 
(
	[score] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[tdiscrolscoremappingTurtle]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tdiscrolscoremappingTurtle](
	[score] [int] NULL,
	[scoreinmap] [float] NULL
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[tempPsychometricTestMapping]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tempPsychometricTestMapping](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[CandidateID] [bigint] NULL,
	[MlqAllow] [nvarchar](500) NULL,
	[lastMlqStatusChange] [datetime] NULL,
	[lastMlqStatusChangeBy] [nvarchar](max) NULL,
 CONSTRAINT [PK_tempPsychometricTestMapping] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruitbigfivecandidatedtls]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruitbigfivecandidatedtls](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[candidateid] [int] NOT NULL,
	[languageid] [int] NOT NULL,
	[questionserialno] [int] NOT NULL,
	[answer] [int] NOT NULL,
	[createdon] [datetime] NOT NULL,
	[updatedon] [datetime] NULL,
	[candidateattemexam] [int] NOT NULL,
	[quesfinalsubmit] [varchar](50) NULL,
 CONSTRAINT [PK_trecruitbigfivecandidatedtls] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruitbigfivecanlanguagemapping]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruitbigfivecanlanguagemapping](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[candidateid] [int] NOT NULL,
	[languageid] [int] NOT NULL,
 CONSTRAINT [PK_trecruitbigfivecanlanguagemapping] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruitbigfiveexamdtls]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruitbigfiveexamdtls](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[candidateid] [int] NOT NULL,
	[languageid] [int] NULL,
	[totalques] [int] NULL,
	[attemques] [int] NULL,
	[finalsubmit] [varchar](50) NULL,
	[attemexam] [int] NULL,
 CONSTRAINT [PK_trecruitbigfiveexamdtls] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruitbigfivequestiondtls]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruitbigfivequestiondtls](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[languageid] [int] NOT NULL,
	[questionserialno] [int] NOT NULL,
	[question] [nvarchar](max) NOT NULL,
	[deleteflag] [varchar](50) NOT NULL,
 CONSTRAINT [PK_trecruitbigfivequestiondtls] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruitconflictansdtls]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruitconflictansdtls](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[languageid] [int] NULL,
	[number] [int] NULL,
	[answer] [nvarchar](max) NULL,
	[activeflag] [varchar](10) NULL,
	[createdby] [varchar](10) NULL,
	[createdon] [datetime] NULL,
	[updateddby] [varchar](10) NULL,
	[updateddon] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruitconflictcandidatedtls]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruitconflictcandidatedtls](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[candidateid] [int] NULL,
	[languageid] [int] NULL,
	[questionid] [int] NULL,
	[answer] [int] NULL,
	[noofattemp] [int] NULL,
	[createdon] [datetime] NULL,
	[updatedon] [datetime] NULL,
	[candidateattemexam] [int] NULL,
	[quesfinalsubmitques] [varchar](50) NULL
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruitconflictcanlanguagemap]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruitconflictcanlanguagemap](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[candidateid] [int] NULL,
	[languageid] [int] NULL,
	[finalsubmit] [varchar](10) NULL,
	[attemexam] [int] NULL
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruitconflictexamdtls]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruitconflictexamdtls](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[candidateid] [int] NULL,
	[languageid] [int] NULL,
	[totalques] [int] NULL,
	[attemques] [int] NULL,
	[finalsubmit] [varchar](10) NULL,
	[attemexam] [int] NULL,
	[Comment] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruitconflictquestype]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruitconflictquestype](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[conquestype] [varchar](100) NULL,
	[activeflag] [varchar](10) NULL,
	[createdby] [varchar](10) NULL,
	[createdon] [datetime] NULL,
	[updateddby] [varchar](10) NULL,
	[updateddon] [datetime] NULL
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruitconflictqusdtls]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruitconflictqusdtls](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[languageid] [int] NULL,
	[quesserialno] [int] NULL,
	[question] [nvarchar](max) NULL,
	[conquestypeid] [int] NULL,
	[activeflag] [varchar](10) NULL,
	[createdby] [varchar](10) NULL,
	[createdon] [datetime] NULL,
	[updateddby] [varchar](10) NULL,
	[updateddon] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruitconflictqusdtls_backup]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruitconflictqusdtls_backup](
	[id] [int] NOT NULL,
	[languageid] [int] NULL,
	[quesserialno] [int] NULL,
	[question] [nvarchar](max) NULL,
	[conquestypeid] [int] NULL,
	[activeflag] [varchar](10) NULL,
	[createdby] [varchar](10) NULL,
	[createdon] [datetime] NULL,
	[updateddby] [varchar](10) NULL,
	[updateddon] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruitdiscrolansdtls]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruitdiscrolansdtls](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[languageid] [int] NULL,
	[number] [int] NULL,
	[answer] [nvarchar](max) NULL,
	[activeflag] [varchar](10) NULL,
	[createdby] [varchar](10) NULL,
	[createdon] [datetime] NULL,
	[updateddby] [varchar](10) NULL,
	[updateddon] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruitdiscrolcandidatedtls]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruitdiscrolcandidatedtls](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[candidateid] [int] NULL,
	[languageid] [int] NULL,
	[questionid] [int] NULL,
	[answer] [int] NULL,
	[noofattemp] [int] NULL,
	[createdon] [datetime] NULL,
	[updatedon] [datetime] NULL,
	[candidateattemexam] [int] NULL,
	[quesfinalsubmitques] [varchar](50) NULL
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruitdiscrolecanlanguagemap]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruitdiscrolecanlanguagemap](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[candidateid] [int] NULL,
	[languageid] [int] NULL,
	[finalsubmit] [varchar](10) NULL,
	[attemexam] [int] NULL
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruitdiscrolexamdtls]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruitdiscrolexamdtls](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[candidateid] [int] NULL,
	[languageid] [int] NULL,
	[totalques] [int] NULL,
	[attemques] [int] NULL,
	[finalsubmit] [varchar](10) NULL,
	[attemexam] [int] NULL,
	[Comment] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruitdiscrolexaminstraction]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruitdiscrolexaminstraction](
	[id] [bigint] NOT NULL,
	[fname] [varchar](50) NULL,
	[ftype] [nvarchar](500) NULL,
	[resumefile] [varbinary](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruitdiscrolquestype]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruitdiscrolquestype](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[disquestype] [varchar](100) NULL,
	[activeflag] [varchar](10) NULL,
	[createdby] [varchar](10) NULL,
	[createdon] [datetime] NULL,
	[updateddby] [varchar](10) NULL,
	[updateddon] [datetime] NULL
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruitdiscrolqusdtls]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruitdiscrolqusdtls](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[languageid] [int] NULL,
	[quesserialno] [int] NULL,
	[question] [nvarchar](max) NULL,
	[disquestypeid] [int] NULL,
	[activeflag] [varchar](10) NULL,
	[createdby] [varchar](10) NULL,
	[createdon] [datetime] NULL,
	[updateddby] [varchar](10) NULL,
	[updateddon] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruitdiscrolratio]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruitdiscrolratio](
	[questype] [varchar](20) NULL,
	[ratio] [float] NULL
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruiteqansmarks]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruiteqansmarks](
	[id] [int] NOT NULL,
	[questionno] [int] NULL,
	[answerno] [int] NULL,
	[answer] [nvarchar](max) NULL,
	[marks] [int] NULL,
	[languageid] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruiteqcandidatedtls]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruiteqcandidatedtls](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[candidateid] [int] NULL,
	[languageid] [int] NULL,
	[exquesset] [int] NULL,
	[Serialno] [int] NULL,
	[questionid] [int] NULL,
	[answer] [int] NULL,
	[noofattemp] [int] NULL,
	[createdon] [datetime] NULL,
	[updatedon] [datetime] NULL,
	[candidateattemexam] [int] NULL,
	[quesfinalsubmitques] [varchar](10) NULL
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruiteqcanlanguagemap]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruiteqcanlanguagemap](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[candidateid] [int] NULL,
	[languageid] [int] NULL,
	[finalsubmit] [varchar](10) NULL,
	[attemexam] [int] NULL
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruiteqexamdtls]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruiteqexamdtls](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[candidateid] [int] NULL,
	[languageid] [int] NULL,
	[totalques] [int] NULL,
	[attemques] [int] NULL,
	[finalsubmit] [varchar](10) NULL,
	[attemexam] [int] NULL,
	[Comment] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruiteqquesdtls]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruiteqquesdtls](
	[id] [int] NOT NULL,
	[languageid] [int] NULL,
	[Queslanset] [int] NULL,
	[Ranquesserialno] [int] NULL,
	[quesserialno] [int] NULL,
	[question] [nvarchar](max) NULL,
	[eqquestypeid] [int] NULL,
	[activeflag] [varchar](10) NULL,
	[createdby] [varchar](200) NULL,
	[createdon] [datetime] NULL,
	[upadtedby] [varchar](200) NULL,
	[updatedon] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruiteqquestype]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruiteqquestype](
	[id] [int] NOT NULL,
	[eqquestype] [varchar](100) NULL,
	[activeflag] [varchar](10) NULL,
	[createdby] [varchar](200) NULL,
	[createdon] [datetime] NULL,
	[updatedby] [varchar](200) NULL,
	[updatedon] [datetime] NULL
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruiteqrandomques]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruiteqrandomques](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[languageid] [int] NULL,
	[quesset] [int] NULL,
	[createddate] [datetime] NULL,
	[candidateid] [int] NULL
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruitfirobcandidatedtls]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruitfirobcandidatedtls](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[candidateid] [int] NOT NULL,
	[languageid] [int] NOT NULL,
	[questionserialno] [int] NOT NULL,
	[answer] [int] NOT NULL,
	[createdon] [datetime] NOT NULL,
	[updatedon] [datetime] NULL,
	[candidateattemexam] [int] NOT NULL,
	[quesfinalsubmit] [varchar](50) NULL,
 CONSTRAINT [PK_trecruitfirobcandidatedtls] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruitfirobcanlanguagemapping]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruitfirobcanlanguagemapping](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[candidateid] [int] NOT NULL,
	[languageid] [int] NOT NULL,
 CONSTRAINT [PK_trecruitfirobcanlanguagemapping] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruitfirobexamdtls]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruitfirobexamdtls](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[candidateid] [int] NOT NULL,
	[languageid] [int] NULL,
	[totalques] [int] NULL,
	[attemques] [int] NULL,
	[finalsubmit] [varchar](50) NULL,
	[attemexam] [int] NULL,
 CONSTRAINT [PK_trecruitfirobexamdtls] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruitfirobquesdtls]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruitfirobquesdtls](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[languageid] [int] NULL,
	[questionserialno] [int] NULL,
	[question] [nvarchar](max) NULL,
	[deleteflag] [varchar](50) NULL,
 CONSTRAINT [PK_trecruitfirobquesdtls] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruitiqansmarks]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruitiqansmarks](
	[id] [int] NOT NULL,
	[questionno] [int] NULL,
	[answerno] [int] NULL,
	[answer] [nvarchar](max) NULL,
	[marks] [int] NULL,
	[languageid] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruitiqcandidatedtls]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruitiqcandidatedtls](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[candidateid] [int] NULL,
	[exquesset] [int] NULL,
	[languageid] [int] NULL,
	[Serialno] [int] NULL,
	[questionid] [int] NULL,
	[answer] [int] NULL,
	[noofattemp] [int] NULL,
	[createdon] [datetime] NULL,
	[updatedon] [datetime] NULL,
	[candidateattemexam] [int] NULL,
	[quesfinalsubmitques] [varchar](50) NULL
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruitiqcanlanguagemap]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruitiqcanlanguagemap](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[candidateid] [int] NULL,
	[languageid] [int] NULL,
	[quesset] [int] NULL,
	[finalsubmit] [varchar](10) NULL,
	[attemexam] [int] NULL,
	[createdtime] [datetime] NULL
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruitiqexamdtls]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruitiqexamdtls](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[candidateid] [int] NULL,
	[languageid] [int] NULL,
	[totalques] [int] NULL,
	[attemques] [int] NULL,
	[finalsubmit] [varchar](10) NULL,
	[attemexam] [int] NULL,
	[Comment] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruitiqquesdtls]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruitiqquesdtls](
	[id] [int] NOT NULL,
	[languageid] [int] NULL,
	[Queslanset] [int] NULL,
	[Ranquesserialno] [int] NULL,
	[quesserialno] [int] NULL,
	[name] [varchar](50) NULL,
	[ContentType] [varchar](50) NULL,
	[question] [image] NULL,
	[eqquestypeid] [int] NULL,
	[activeflag] [varchar](10) NULL,
	[createdby] [varchar](200) NULL,
	[createdon] [datetime] NULL,
	[upadtedby] [varchar](200) NULL,
	[updatedon] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruitiqrandomques]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruitiqrandomques](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[languageid] [int] NULL,
	[quesset] [int] NULL,
	[createddate] [datetime] NULL,
	[candidateid] [int] NULL
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruitmyersbiggsexamdtls]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruitmyersbiggsexamdtls](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[candidateid] [int] NOT NULL,
	[languageid] [int] NULL,
	[totalques] [int] NULL,
	[attemques] [int] NULL,
	[finalsubmit] [varchar](50) NULL,
	[attemexam] [int] NULL,
 CONSTRAINT [PK_trecruitmyersbiggsexamdtls] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruitmyersbriggsanswer]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruitmyersbriggsanswer](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[questionno] [int] NULL,
	[answerno] [int] NULL,
	[answer] [nvarchar](max) NULL,
	[languageid] [int] NULL,
 CONSTRAINT [PK_trecruitmyersbriggsanswer] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruitmyersbriggscandidatedtls]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruitmyersbriggscandidatedtls](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[candidateid] [int] NOT NULL,
	[languageid] [int] NOT NULL,
	[questionserialno] [int] NOT NULL,
	[answer] [int] NOT NULL,
	[createdon] [datetime] NOT NULL,
	[updatedon] [datetime] NULL,
	[candidateattemexam] [int] NOT NULL,
	[quesfinalsubmit] [varchar](50) NULL,
 CONSTRAINT [PK_trecruitmyersbriggscandidatedtls] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruitmyersbriggscanlanguagemapping]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruitmyersbriggscanlanguagemapping](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[candidateid] [int] NOT NULL,
	[languageid] [int] NOT NULL,
 CONSTRAINT [PK_trecruitmyersbriggscanlanguagemapping] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruitmyersbriggsquesdtls]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruitmyersbriggsquesdtls](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[languageid] [int] NULL,
	[questionserialno] [int] NULL,
	[question] [nvarchar](max) NOT NULL,
	[deleteflag] [varchar](50) NULL,
 CONSTRAINT [PK_trecruitmyersbriggsquesdtls] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruitrotterlocusofcontrolanswer]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruitrotterlocusofcontrolanswer](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[questionno] [int] NULL,
	[answerno] [int] NULL,
	[answer] [nvarchar](max) NULL,
	[languageid] [int] NULL,
 CONSTRAINT [PK_trecruitrotterlocusofcontrolanswer] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruitrotterlocusofcontrolcandidatedtls]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruitrotterlocusofcontrolcandidatedtls](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[candidateid] [int] NOT NULL,
	[languageid] [int] NOT NULL,
	[questionserialno] [int] NOT NULL,
	[answer] [int] NOT NULL,
	[createdon] [datetime] NOT NULL,
	[updatedon] [datetime] NULL,
	[candidateattemexam] [int] NOT NULL,
	[quesfinalsubmit] [varchar](50) NULL,
 CONSTRAINT [PK_trecruitrotterlocusofcontrolcandidatedtls] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruitrotterlocusofcontrolcanlanguagemapping]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruitrotterlocusofcontrolcanlanguagemapping](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[candidateid] [int] NOT NULL,
	[languageid] [int] NOT NULL,
 CONSTRAINT [PK_trecuitrotterlocusofcontrolcanlanguagemapping] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruitrotterlocusofcontrolexamdtls]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruitrotterlocusofcontrolexamdtls](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[candidateid] [int] NOT NULL,
	[languageid] [int] NULL,
	[totalques] [int] NULL,
	[attemques] [int] NULL,
	[finalsubmit] [varchar](50) NULL,
	[attemexam] [int] NULL,
 CONSTRAINT [PK_trecruitrotterlocusofcontrolexamdtls] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[trecruitrotterlocusofcontrolquesdtls]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trecruitrotterlocusofcontrolquesdtls](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[questionserialno] [int] NULL,
	[question] [nvarchar](max) NOT NULL,
	[languageid] [int] NULL,
	[deleteflag] [varchar](50) NULL,
 CONSTRAINT [PK_trecruitrotterlocusofcontrolquesdtls] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO




/* ----------------------------------------------------------------------------
   6. TESTS / PSYCHOMETRIC ASSESSMENTS + REPORTS - Driscol/DISC, Conflict, EQ, IQ and other assessments
   STORED PROCEDURES
---------------------------------------------------------------------------- */

/* ---- PRIMARY / NON-TEMP PROCEDURES ---- */

/* ========================== STORED PROCEDURES ========================== */
/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: trecruitbigfiveexamdtls, trecruitcanbasicdtls */
/****** Object:  StoredProcedure [dbo].[bigfivehrdtls]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[bigfivehrdtls]
@candidateattemexam INT=NULL, 
@registrationnumber VARCHAR(200)=NULL,
@action varchar(200)
as
declare @candidateid int
begin
SELECT @candidateid = candidateid 
      FROM   [dbo].[trecruitcanbasicdtls] 
      WHERE  registrationnumber = @registrationnumber 
IF @action = 'SELECTEXAMNO' 
        BEGIN 
            SELECT [attemexam], 
                   CASE 
                     WHEN [attemexam] = 1 THEN Cast('1st Exam' AS VARCHAR) 
                     WHEN [attemexam] = 2 THEN Cast('2nd Exam'AS VARCHAR) 
                     WHEN [attemexam] = 3 THEN Cast('3rd Exam'AS VARCHAR) 
                     ELSE Cast([attemexam]AS VARCHAR) + '' + 'th Exam' 
                   END [attemexamtext] 
            FROM   [dbo].[trecruitbigfiveexamdtls] 
            WHERE  candidateid = @candidateid 
                   AND finalsubmit = 'Yes' 
            ORDER  BY [attemexam] 
        END 
end
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: tempPsychometricTestMapping, test, trecruitcanbasicdtls, trecruitcandidatesignup */
/****** Object:  StoredProcedure [dbo].[PRC_Candidate_MlqDocumetMapping]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PRC_Candidate_MlqDocumetMapping]      
   @referenceno varchar(max)=null,     
   @Discrolallow VARCHAR(500)=NULL,  
   @Conflictallow varchar(500)=NULL,  
   @Iqallow VARCHAR(500)=NULL,  
   @Eqallow  VARCHAR(500)=NULL,  
   --@docuploadallow varchar(max)=null,    
   @MlqAllow VARCHAR(50)=NULL,            
   @MlqAllowExamUrl nvarchar(MAX)=NULL,    
   @Action varchar(max)      
as        
 declare  @candidateid bigint    
 declare  @candidatename nvarchar(max)    
begin      
    
   Select @candidateid=candidateid,    
    @candidatename=(firstname+' '+middlename+' '+lastname)    
   from trecruitcanbasicdtls where registrationnumber=@referenceno    
     
   if @Action ='INSERT'      
   BEGIN      
         -- Update only columns where parameter is NOT NULL; if param IS NULL keep existing value  
       UPDATE [dbo].[trecruitcanbasicdtls]  
       SET  
         discrolallow  = COALESCE(@Discrolallow, discrolallow),  
         conflictallow = COALESCE(@Conflictallow, conflictallow),  
         iqallow       = COALESCE(@Iqallow, iqallow),  
         bigfiveallow  = COALESCE(@Iqallow, bigfiveallow),  -- kept as original; change if needed  
         eqallow       = COALESCE(@Eqallow, eqallow)  
       WHERE [registrationnumber] = @referenceno;      
    
      
----------------------MLQ TEST ASSING START-----------------------------------              
 IF NOT EXISTS(SELECT * FROM [tempPsychometricTestMapping] WHERE CandidateID=@candidateid)            
 BEGIN                  
  IF @MlqAllow IS NOT NULL            
  BEGIN            
   Declare @MailId varchar(max)                                           
   Declare @tableHTML nvarchar(max)                                          
   Declare @mailSubject nvarchar(max)               
   Declare @CandidaFullName nvarchar(max)              
   --Declare @PostName nvarchar(max)              
   Declare @CandidateMail nvarchar(max)              
               
               
            
     SELECT @CandidateMail=MailId FROM trecruitcandidatesignup WHERE CandidateID=@candidateid            
     INSERT [tempPsychometricTestMapping]            
   (CandidateID, MlqAllow, lastMlqStatusChange)            
     VALUES(@candidateid, 'Yes', GETDATE());            
            
               
               
            
     SET @mailSubject = 'Invitation to Complete the Multifactor Leadership Questionnaire (MLQ)';            
            
               
    -- HTML Body            
     SET @tableHTML =             
     '<table style="font-size:16px; font-family:Tahoma; line-height:22px; width:650px;">            
     <tr>            
    <td>Dear ' + @CandidateName + ',</td>            
     </tr>            
            
     <tr><td style="height:15px;"></td></tr>            
            
     <tr>            
    <td>            
      As part of our commitment to understanding and developing strong leadership,             
      we would like to invite you to complete the <b>Multifactor Leadership Questionnaire (MLQ)</b>.             
      This psychometric assessment will provide valuable insights into your leadership style </b>.            
    </td>            
     </tr>            
            
     <tr><td style="height:20px;"></td></tr>            
            
                  
     <tr><td style="height:20px;"></td></tr>            
            
     <tr>            
    <td>            
      <b>How to Start:</b><br/>            
      To begin the assessment, please click on the link below:<br/><br/>            
      <a href="' + @MlqAllowExamUrl + '"             
      style="background-color:#0E7777; color:#ffffff; padding:10px 18px;             
    text-decoration:none; border-radius:6px; font-weight:bold;">            
     Start the MLQ Test            
      </a>            
    </td>            
     </tr>            
            
     <tr><td style="height:20px;"></td></tr>            
            
     <tr>            
    <td>            
      We recommend taking the test in a quiet, distraction-free environment to ensure you can focus.            
    </td>            
     </tr>            
            
     <tr><td style="height:20px;"></td></tr>            
            
     <tr>            
    <td>            
      The results of this assessment will be used to help you, your manager, and our leadership team             
      understand your unique strengths and how you can be most effective in your role.            
    </td>            
     </tr>            
            
     <tr><td style="height:20px;"></td></tr>            
            
     <tr>            
    <td>            
      If you have any questions or experience any technical issues,             
      please contact concerned HR, or <a href="mailto:bipro.das@mendine.com">bipro.das@mendine.com</a>.            
    </td>            
     </tr>            
            
     <tr><td style="height:30px;"></td></tr>            
            
     <tr>            
    <td>            
      Thank you for your cooperation. We look forward to seeing your results.            
    </td>            
     </tr>            
            
     <tr><td style="height:30px;"></td></tr>            
            
     <tr>            
    <td>            
      Thanks & Regards,<br/><i>Mendine HR Team</i>             
    </td>            
      </tr>            
   </table>';            
            
                
         EXEC msdb.dbo.sp_send_dbmail                
       @profile_name = 'Mendine_Recruitment_Profile'                
       , @recipients = @CandidateMail                
       , @subject = @mailSubject                
       , @body = @tableHTML                
       , @importance = 'HIGH'                
         , @body_format = 'HTML'               
            
    END            
   END             
 ----------------------MLQ TEST ASSING END-----------------------------------           
    End         
       
   if @Action='SELECT'    
   BEGIN    
          
   SELECT     
      tb.[docsubmissionallow],  
   tb.discrolallow,  
   tb.conflictallow,  
   tb.iqallow,  
      tb.bigfiveallow,  
      tb.eqallow,   
     CASE                                     
     WHEN mlq.[MlqAllow] IS NULL THEN 'No'                                     
     ELSE mlq.[MlqAllow]                                     
     END As MlqAllow        
    
   FROM  [dbo].[trecruitcanbasicdtls] tb    
    LEFT JOIN [dbo].[tempPsychometricTestMapping] mlq ON tb.candidateid = mlq.CandidateID    
    where tb.registrationnumber=@referenceno    
   END    
end   
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: tempPsychometricTestMapping, test, trecruitcanbasicdtls, trecruitcandidatesignup */
/****** Object:  StoredProcedure [dbo].[PRC_Candidate_TestMapping]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[PRC_Candidate_TestMapping]      
   @referenceno varchar(max)=null,     
   @Discrolallow VARCHAR(500)=NULL,  
   @Conflictallow varchar(500)=NULL,  
   @Iqallow VARCHAR(500)=NULL,  
   @Eqallow  VARCHAR(500)=NULL,  
   --@docuploadallow varchar(max)=null,    
   @MlqAllow VARCHAR(50)=NULL,            
   @MlqAllowExamUrl nvarchar(MAX)=NULL,    
   @Action varchar(max)      
as        
 declare  @candidateid bigint    
 declare  @candidatename nvarchar(max)    
begin      
    
   Select @candidateid=candidateid,    
    @candidatename=(firstname+' '+middlename+' '+lastname)    
   from trecruitcanbasicdtls where registrationnumber=@referenceno    
     
   if @Action ='INSERT'      
   BEGIN      
         -- Update only columns where parameter is NOT NULL; if param IS NULL keep existing value  
       UPDATE [dbo].[trecruitcanbasicdtls]  
       SET  
         discrolallow  = COALESCE(@Discrolallow, discrolallow),  
         conflictallow = COALESCE(@Conflictallow, conflictallow),  
         iqallow       = COALESCE(@Iqallow, iqallow),  
         bigfiveallow  = COALESCE(@Iqallow, bigfiveallow),  -- kept as original; change if needed  
         eqallow       = COALESCE(@Eqallow, eqallow)  
       WHERE [registrationnumber] = @referenceno;      
    
      
----------------------MLQ TEST ASSING START-----------------------------------              
 IF NOT EXISTS(SELECT * FROM [tempPsychometricTestMapping] WHERE CandidateID=@candidateid)            
 BEGIN                  
  IF @MlqAllow IS NOT NULL            
  BEGIN            
   Declare @MailId varchar(max)                                           
   Declare @tableHTML nvarchar(max)                                          
   Declare @mailSubject nvarchar(max)               
   Declare @CandidaFullName nvarchar(max)              
   --Declare @PostName nvarchar(max)              
   Declare @CandidateMail nvarchar(max)              
               
               
            
     SELECT @CandidateMail=MailId FROM trecruitcandidatesignup WHERE CandidateID=@candidateid            
     INSERT [tempPsychometricTestMapping]            
   (CandidateID, MlqAllow, lastMlqStatusChange)            
     VALUES(@candidateid, 'Yes', GETDATE());            
            
               
               
            
     SET @mailSubject = 'Invitation to Complete the Multifactor Leadership Questionnaire (MLQ)';            
            
               
    -- HTML Body            
     SET @tableHTML =             
     '<table style="font-size:16px; font-family:Tahoma; line-height:22px; width:650px;">            
     <tr>            
    <td>Dear ' + @CandidateName + ',</td>            
     </tr>            
            
     <tr><td style="height:15px;"></td></tr>            
            
     <tr>            
    <td>            
      As part of our commitment to understanding and developing strong leadership,             
      we would like to invite you to complete the <b>Multifactor Leadership Questionnaire (MLQ)</b>.             
      This psychometric assessment will provide valuable insights into your leadership style </b>.            
    </td>            
     </tr>            
            
     <tr><td style="height:20px;"></td></tr>            
            
                  
     <tr><td style="height:20px;"></td></tr>            
            
     <tr>            
    <td>            
      <b>How to Start:</b><br/>            
      To begin the assessment, please click on the link below:<br/><br/>            
      <a href="' + @MlqAllowExamUrl + '"             
      style="background-color:#0E7777; color:#ffffff; padding:10px 18px;             
    text-decoration:none; border-radius:6px; font-weight:bold;">            
     Start the MLQ Test            
      </a>            
    </td>            
     </tr>            
            
     <tr><td style="height:20px;"></td></tr>            
            
     <tr>            
    <td>            
      We recommend taking the test in a quiet, distraction-free environment to ensure you can focus.            
    </td>            
     </tr>            
            
     <tr><td style="height:20px;"></td></tr>            
            
     <tr>            
    <td>            
      The results of this assessment will be used to help you, your manager, and our leadership team             
      understand your unique strengths and how you can be most effective in your role.            
    </td>            
     </tr>            
            
     <tr><td style="height:20px;"></td></tr>            
            
     <tr>            
    <td>            
      If you have any questions or experience any technical issues,             
      please contact concerned HR, or <a href="mailto:bipro.das@mendine.com">bipro.das@mendine.com</a>.            
    </td>            
     </tr>            
            
     <tr><td style="height:30px;"></td></tr>            
            
     <tr>            
    <td>            
      Thank you for your cooperation. We look forward to seeing your results.            
    </td>            
     </tr>            
            
     <tr><td style="height:30px;"></td></tr>            
            
     <tr>            
    <td>            
      Thanks & Regards,<br/><i>Mendine HR Team</i>             
    </td>            
      </tr>            
   </table>';            
            
                
         EXEC msdb.dbo.sp_send_dbmail                
       @profile_name = 'Mendine_Recruitment_Profile'                
       , @recipients = @CandidateMail                
       , @subject = @mailSubject                
       , @body = @tableHTML                
       , @importance = 'HIGH'                
         , @body_format = 'HTML'               
            
    END            
   END             
 ----------------------MLQ TEST ASSING END-----------------------------------           
    End         
       
   if @Action='SELECT'    
   BEGIN    
          
   SELECT     
      tb.[docsubmissionallow],  
   tb.discrolallow,  
   tb.conflictallow,  
   tb.iqallow,  
      tb.bigfiveallow,  
      tb.eqallow,   
     CASE                                     
     WHEN mlq.[MlqAllow] IS NULL THEN 'No'                                     
     ELSE mlq.[MlqAllow]                                     
     END As MlqAllow        
    
   FROM  [dbo].[trecruitcanbasicdtls] tb    
    LEFT JOIN [dbo].[tempPsychometricTestMapping] mlq ON tb.candidateid = mlq.CandidateID    
    where tb.registrationnumber=@referenceno    
   END    
end   
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: tempPsychometricTestMapping, trecruitcandidatesignup */
/****** Object:  StoredProcedure [dbo].[PRC_GetCandidatePsychometricTesStatus]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[PRC_GetCandidatePsychometricTesStatus]          
  @username nvarchar(max)          
as     
        DECLARE @candidateid INT  
begin              
   SELECT @candidateid = candidateid     
      FROM   [trecruitcandidatesignup]     
      WHERE  [username] = @username     
  
 if exists(Select CandidateID from [tempPsychometricTestMapping] where CandidateID=@candidateid)          
 begin          
     
    SELECT MlqAllow FROM  [tempPsychometricTestMapping] where CandidateID=@candidateid 
 end          
 else           
 begin          
    Select 'No' MlqAllow  ----ishita       
    -- Select 'No' bigfiveallow,'No'firoballow,'No' myersbriggsallow,'No' rotterlocusofcontrolallow,'No' personalitystyleinventoryallow,'No'IQTest,'No'EQTest ,'No' ConflictTest,'No'DriscoleTest ----ishita          
 end          
end 
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: tempPsychometricTestMapping, trecruitcanbasicdtls, trecruitcandidatesignup */
/****** Object:  StoredProcedure [dbo].[PRC_GetCandidatePsychometricTesStatus_Registrationnumber]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[PRC_GetCandidatePsychometricTesStatus_Registrationnumber]    -- 'Candidate006139'        
   @registrationnumber nvarchar(max)=NULL    
     
as       
        DECLARE @candidateid INT   
  DECLARE @UserName nvarchar(max)   
begin                
   SELECT @candidateid = candidateid         
      FROM   [dbo].[trecruitcanbasicdtls]         
      WHERE  registrationnumber = @registrationnumber      
    
      select @UserName= username  from trecruitcandidatesignup where CandidateID=@candidateid  
  
 if exists(Select CandidateID  from [tempPsychometricTestMapping] where CandidateID=@candidateid)            
 begin            
       
    SELECT MlqAllow,@UserName as username FROM  [tempPsychometricTestMapping]   where   CandidateID=@candidateid   
 end            
 else             
 begin            
    Select 'No' MlqAllow,@UserName as username ----ishita         
    -- Select 'No' bigfiveallow,'No'firoballow,'No' myersbriggsallow,'No' rotterlocusofcontrolallow,'No' personalitystyleinventoryallow,'No'IQTest,'No'EQTest ,'No' ConflictTest,'No'DriscoleTest ----ishita            
 end            
end 
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: tcandidateappointmentmapping, tofferlatterdtls, trecruitcanbasicdtls, trecruitcandidatesignup, trecruitconflictexamdtls, trecruitdiscrolexamdtls, trecruiteqexamdtls, trecruitiqexamdtls */
/****** Object:  StoredProcedure [dbo].[PRC_Sync_Data_Candidate_Detail]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- PRC_Sync_Data_Candidate_Detail 230   
    
CREATE Proc [dbo].[PRC_Sync_Data_Candidate_Detail]    
@IDCandidate  Bigint    
As    
Begin      
  Select * into #temptestresult      
  from (    
  SELECT   a.[candidateid],      
   case      
     when a.[attemexam] is null then 0      
     when a.[attemexam]='' then 0      
     else  a.[attemexam]      
     end discrolexamno,      
  case      
     when b.[attemexam] is null then 0      
     when b.[attemexam]='' then 0      
     else  b.[attemexam]      
     end eqexamno,      
  case      
     when c.[attemexam] is null then 0      
     when c.[attemexam]='' then 0      
     else c.[attemexam]      
     end conflictexamno,      
  case      
     when d.[attemexam] is null then 0      
     when d.[attemexam]='' then 0      
     else d.[attemexam]      
     end iqexamno      
  FROM       
 ( Select  candidateid,max([attemexam])[attemexam]     
  from  [dbo].[trecruitdiscrolexamdtls]    
  where  finalsubmit='Yes'     
  and   candidateid=@IDCandidate     
  group by candidateid     
 ) a     
 Left Join     
(  Select candidateid, max([attemexam])[attemexam]     
  from [dbo].[trecruiteqexamdtls] where finalsubmit='Yes'     
  and candidateid=@IDCandidate group by candidateid     
 ) b on a.candidateid=b.candidateid      
 Left Join     
 ( Select candidateid, max([attemexam])[attemexam]     
  from [dbo].[trecruitconflictexamdtls]     
  where finalsubmit='Yes'     
  and  candidateid=@IDCandidate     
  group by candidateid     
 )  c on a.candidateid=c.candidateid     
 Left Join     
 ( Select  candidateid, max([attemexam])[attemexam]     
  from  [dbo].[trecruitiqexamdtls] where finalsubmit='Yes'     
  and   candidateid=@IDCandidate group by candidateid     
 ) d on a.candidateid=d.candidateid    
 )ab      
    
    
    Select * into #tempbasic      
 from (     
  Select  a.candidateid, registrationnumber,username     
  from  trecruitcanbasicdtls a    
  Inner Join trecruitcandidatesignup b on  a.candidateid=b.candidateid       
  where  a.candidateid=@IDCandidate    
  ) a      
    
  Select * into #tempofferappointment      
  from(    
   Select  a.[candidateid],a.[appointmentlettertype],     
      a.[empno],b.[offerdcompanycode]      
   from  tcandidateappointmentmapping a    
   Left Join tofferlatterdtls    b  On a.candidateid=b.candidateid       
   where  a.deleteflag='No'      
   and   b.deleteflag='No'      
   and   a.[candidateid]=@IDCandidate    
   ) a      
      
 Select   a.[candidateid],a.discrolexamno, a.eqexamno,      
     a.conflictexamno,a.iqexamno, b.registrationnumber,      
     b.username,c.[appointmentlettertype],c.[offerdcompanycode],c.[empno]      
 from   #temptestresult   a    
 Left Join   #tempbasic    b on a.[candidateid]=b.[candidateid]      
 Left Join  #tempofferappointment c on a.[candidateid]=c.[candidateid]    
    

    drop table #temptestresult      
    drop table #tempbasic      
    drop table #tempofferappointment      
    
End      
 -- PRC_Sync_Data_Candidate_Detail 2470
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: trecruitcanbasicdtls, trecruitconflictexamdtls */
/****** Object:  StoredProcedure [dbo].[Proc_addConflictcmt]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure  [dbo].[Proc_addConflictcmt]         
@comment nvarchar(max),        
@registrationno varchar(100) ,      
@examno int      
AS         
BEGIN      
  Declare @candidateid bigint    
  select @candidateid = candidateid from trecruitcanbasicdtls where registrationnumber = @registrationno    
    
  if(@examno = 1)      
  begin      
 update trecruitconflictexamdtls set Comment=@comment where candidateid=@candidateid and attemexam=@examno      
  end      
  else       
 update trecruitconflictexamdtls set Comment=@comment where candidateid=@candidateid and attemexam=@examno     
END
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: trecruitcanbasicdtls, trecruitdiscrolexamdtls */
/****** Object:  StoredProcedure [dbo].[Proc_adddiscrolcmt]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure  [dbo].[Proc_adddiscrolcmt]           
@comment  nvarchar(max),          
@registrationno varchar(100) ,        
@examno int        
AS           
BEGIN        
  Declare @candidateid bigint      
  select @candidateid = candidateid from trecruitcanbasicdtls where registrationnumber = @registrationno      
      
  if(@examno = 1)        
  begin        
 update trecruitdiscrolexamdtls set Comment=@comment where candidateid=@candidateid and attemexam=@examno        
  end        
  else         
 update trecruitdiscrolexamdtls set Comment=@comment where candidateid=@candidateid and attemexam=@examno       
END
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: trecruitcanbasicdtls, trecruiteqexamdtls */
/****** Object:  StoredProcedure [dbo].[Proc_addEqcmt]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure  [dbo].[Proc_addEqcmt]                 
@comment nvarchar(max),                
@registrationnumber varchar(100) ,              
@examno int              
AS                 
BEGIN              
  Declare @candidateid bigint            
  select @candidateid = candidateid from trecruitcanbasicdtls where registrationnumber = @registrationnumber          
            
  if(@examno = 1)              
  begin              
 update trecruiteqexamdtls set Comment=@comment where candidateid=@candidateid and attemexam=@examno              
  end              
  else               
 update trecruiteqexamdtls set Comment=@comment where candidateid=@candidateid and attemexam=@examno             
END
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: trecruitcanbasicdtls, trecruitiqexamdtls */
/****** Object:  StoredProcedure [dbo].[Proc_addIQcmt]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure  [dbo].[Proc_addIQcmt]             
@comment  nvarchar(max),            
@registrationno varchar(100) ,          
@examno int          
AS             
BEGIN          
  Declare @candidateid bigint        
  select @candidateid = candidateid from trecruitcanbasicdtls where registrationnumber = @registrationno        
        
  if(@examno = 1)          
  begin          
 update trecruitiqexamdtls set Comment=@comment where candidateid=@candidateid and attemexam=@examno          
  end          
  else           
 update trecruitiqexamdtls set Comment=@comment where candidateid=@candidateid and attemexam=@examno         
END
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: trecruitcanbasicdtls, trecruitconflictexamdtls */
/****** Object:  StoredProcedure [dbo].[Proc_deleteConflictcmt]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure  [dbo].[Proc_deleteConflictcmt]             
         
@registrationno varchar(100) ,          
@examno int          
AS             
BEGIN          
  Declare @candidateid bigint        
  select @candidateid = candidateid from trecruitcanbasicdtls where registrationnumber = @registrationno        
        
  if(@examno = 1)          
  begin          
 update trecruitconflictexamdtls set Comment='' where candidateid=@candidateid and attemexam=@examno          
  end          
  else           
 update trecruitconflictexamdtls set Comment='' where candidateid=@candidateid and attemexam=@examno         
END
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: trecruitcanbasicdtls, trecruitdiscrolexamdtls */
/****** Object:  StoredProcedure [dbo].[Proc_deletediscrolcmt]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure  [dbo].[Proc_deletediscrolcmt]             
           
@registrationno varchar(100) ,          
@examno int          
AS             
BEGIN          
  Declare @candidateid bigint        
  select @candidateid = candidateid from trecruitcanbasicdtls where registrationnumber = @registrationno        
        
  if(@examno = 1)          
  begin          
 update trecruitdiscrolexamdtls set Comment='' where candidateid=@candidateid and attemexam=@examno          
  end          
  else           
 update trecruitdiscrolexamdtls set Comment='' where candidateid=@candidateid and attemexam=@examno         
END
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: trecruitcanbasicdtls, trecruiteqexamdtls */
/****** Object:  StoredProcedure [dbo].[Proc_deleteEqcmt]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure  [dbo].[Proc_deleteEqcmt]                   
               
@registrationnumber varchar(100) ,                
@examno int                
AS                   
BEGIN                
  Declare @candidateid bigint              
  select @candidateid = candidateid from trecruitcanbasicdtls where registrationnumber = @registrationnumber            
              
  if(@examno = 1)                
  begin                
 update trecruiteqexamdtls set Comment='' where candidateid=@candidateid and attemexam=@examno                
  end                
  else                 
 update trecruiteqexamdtls set Comment='' where candidateid=@candidateid and attemexam=@examno               
END
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: trecruitcanbasicdtls, trecruitiqexamdtls */
/****** Object:  StoredProcedure [dbo].[Proc_deleteIQcmt]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure  [dbo].[Proc_deleteIQcmt]               
           
@registrationno varchar(100) ,            
@examno int            
AS               
BEGIN            
  Declare @candidateid bigint          
  select @candidateid = candidateid from trecruitcanbasicdtls where registrationnumber = @registrationno          
          
  if(@examno = 1)            
  begin            
 update trecruitiqexamdtls set Comment='' where candidateid=@candidateid and attemexam=@examno            
  end            
  else             
 update trecruitiqexamdtls set Comment='' where candidateid=@candidateid and attemexam=@examno           
END
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: trecruitcanbasicdtls, trecruitconflictexamdtls */
/****** Object:  StoredProcedure [dbo].[Proc_DisplayConflictcmt]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Proc_DisplayConflictcmt]
@registrationno varchar(100) ,    
@examno int
As      
Begin   

  Select B.Comment From trecruitcanbasicdtls	A
  Inner Join trecruitconflictexamdtls	B
  On A.candidateid = B.candidateid
  Where A.registrationnumber = @registrationno
  And B.attemexam = @examno

      
End
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: trecruitcanbasicdtls, trecruitdiscrolexamdtls */
/****** Object:  StoredProcedure [dbo].[Proc_Displaydiscrolcmt]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Proc_Displaydiscrolcmt]  
@registrationno varchar(100) ,      
@examno int  
As        
Begin     
  
  Select B.Comment From trecruitcanbasicdtls A  
  Inner Join trecruitdiscrolexamdtls B  
  On A.candidateid = B.candidateid  
  Where A.registrationnumber = @registrationno  
  And B.attemexam = @examno  
  
        
End
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: trecruitcanbasicdtls, trecruiteqexamdtls */
/****** Object:  StoredProcedure [dbo].[Proc_DisplayEQcmt]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
      
    
CREATE PROCEDURE [dbo].[Proc_DisplayEQcmt]      
@registrationno varchar(100) ,          
@examno int      
As            
Begin         
      
  Select B.Comment From trecruitcanbasicdtls A      
  Inner Join trecruiteqexamdtls B      
  On A.candidateid = B.candidateid      
  Where A.registrationnumber = @registrationno      
  And B.attemexam = @examno      
      
            
End
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: trecruitcanbasicdtls, trecruitiqexamdtls */
/****** Object:  StoredProcedure [dbo].[Proc_DisplayIqcmt]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
  
CREATE PROCEDURE [dbo].[Proc_DisplayIqcmt]    
@registrationno varchar(100) ,        
@examno int    
As          
Begin       
    
  Select B.Comment From trecruitcanbasicdtls A    
  Inner Join trecruitiqexamdtls B    
  On A.candidateid = B.candidateid    
  Where A.registrationnumber = @registrationno    
  And B.attemexam = @examno    
    
          
End
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: TBL_MLQ_ansmarks, TBL_MLQ_empdtls, trecruitcanbasicdtls */
/****** Object:  StoredProcedure [dbo].[PROC_MLQ_TEST_Outcome_Qusction]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_MLQ_TEST_Outcome_Qusction]
    @registrationnumber VARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @candidateid INT;

    SELECT @candidateid = candidateid
    FROM dbo.trecruitcanbasicdtls
    WHERE registrationnumber = @registrationnumber;

    IF @candidateid IS NULL
    BEGIN
        RAISERROR('Candidate not found with the provided registration number',16,1);
        RETURN;
    END;

    -- Dynamic list of all answered question IDs
    DECLARE @cols NVARCHAR(MAX), @sql NVARCHAR(MAX);

    SELECT @cols = STRING_AGG(QUOTENAME('Q' + CAST(questionid AS VARCHAR(10))), ',')
    FROM (
        SELECT DISTINCT questionid
        FROM dbo.TBL_MLQ_empdtls
        WHERE CandidateID = @candidateid
    ) AS q;

    SET @sql = '
        SELECT ' + @cols + '
        FROM (
            SELECT ''Q'' + CAST(e.questionid AS VARCHAR(10)) AS QCol,
                   m.marks
            FROM dbo.TBL_MLQ_empdtls e
            INNER JOIN dbo.TBL_MLQ_ansmarks m
                ON e.questionid = m.questionno
               AND e.answer = m.answerno
            WHERE e.CandidateID = ' + CAST(@candidateid AS VARCHAR(10)) + '
        ) src
        PIVOT (
            MAX(marks) FOR QCol IN (' + @cols + ')
        ) p;
    ';

    EXEC sp_executesql @sql;
END;
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: TBL_MLQ_ansmarks, TBL_MLQ_empdtls, trecruitcanbasicdtls */
/****** Object:  StoredProcedure [dbo].[PROC_MLQ_TEST_Outcome_REPORT]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_MLQ_TEST_Outcome_REPORT]  
    @registrationnumber VARCHAR(200) = NULL  
AS  
BEGIN  
    DECLARE @candidateid INT  
  
    -- Get candidate ID  
    SELECT @candidateid = candidateid  
    FROM [dbo].[trecruitcanbasicdtls]  
    WHERE registrationnumber = @registrationnumber  
  
    -- Check if candidate exists  
    IF @candidateid IS NULL  
    BEGIN  
        RAISERROR('Candidate not found with the provided registration number', 16, 1)  
        RETURN  
    END  
    -- Calculate all scores and return as single row  
    SELECT   
          CAST(SUM(CASE WHEN e.questionid IN (39,42,44) THEN m.marks ELSE 0 END) AS DECIMAL(10, 2)) / 3 AS [ExtraEffort],
		  CAST(SUM(CASE WHEN e.questionid IN (37,40,43,45) THEN m.marks ELSE 0 END) AS DECIMAL(10, 2)) / 4 AS [Effectiveness],
		  CAST(SUM(CASE WHEN e.questionid IN (38,41) THEN m.marks ELSE 0 END) AS DECIMAL(10, 2)) / 2 AS [Satisfaction]
          
     FROM TBL_MLQ_empdtls e
    INNER JOIN TBL_MLQ_ansmarks m 
        ON e.questionid = m.questionno 
        AND e.answer = m.answerno
    WHERE e.CandidateID = @candidateid
  
END  
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: TBL_MLQ_ansmarks, TBL_MLQ_empdtls, trecruitcanbasicdtls */
/****** Object:  StoredProcedure [dbo].[PROC_MLQ_TEST_REPORT]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_MLQ_TEST_REPORT]    
    @registrationnumber VARCHAR(200) = NULL    
AS    
BEGIN    
    DECLARE @candidateid INT;    
    
    SELECT @candidateid = candidateid    
    FROM [dbo].[trecruitcanbasicdtls]    
    WHERE registrationnumber = @registrationnumber;    
    
    IF @candidateid IS NULL    
    BEGIN    
        RAISERROR('Candidate not found with the provided registration number', 16, 1);    
        RETURN;    
    END;    
    
    SELECT    
        /* ── Transformational Subscales ── */    
        CAST(ROUND(SUM(CASE WHEN e.questionid IN (10,18,21,25) THEN m.marks ELSE 0 END) / 4.0, 2) AS DECIMAL(10,2)) AS Idealized_influence_attribute,    
        SUM(CASE WHEN e.questionid IN (10,18,21,25) THEN m.marks ELSE 0 END) AS Idealized_influence_attribute_sum,    
    
        CAST(ROUND(SUM(CASE WHEN e.questionid IN (6,14,23,34) THEN m.marks ELSE 0 END) / 4.0, 2) AS DECIMAL(10,2)) AS Idealized_influence_behaviour,    
        SUM(CASE WHEN e.questionid IN (6,14,23,34) THEN m.marks ELSE 0 END) AS Idealized_influence_behaviour_sum,    
    
        CAST(ROUND(SUM(CASE WHEN e.questionid IN (9,13,26,36) THEN m.marks ELSE 0 END) / 4.0, 2) AS DECIMAL(10,2)) AS Inspirational_motivation,    
        SUM(CASE WHEN e.questionid IN (9,13,26,36) THEN m.marks ELSE 0 END) AS Inspirational_motivation_sum,    
    
        CAST(ROUND(SUM(CASE WHEN e.questionid IN (2,8,30,32) THEN m.marks ELSE 0 END) / 4.0, 2) AS DECIMAL(10,2)) AS Intellectual_simulation,    
        SUM(CASE WHEN e.questionid IN (2,8,30,32) THEN m.marks ELSE 0 END) AS Intellectual_simulation_sum,    
    
        CAST(ROUND(SUM(CASE WHEN e.questionid IN (15,19,29,31) THEN m.marks ELSE 0 END) / 4.0, 2) AS DECIMAL(10,2)) AS Individualised_consideration,    
        SUM(CASE WHEN e.questionid IN (15,19,29,31) THEN m.marks ELSE 0 END) AS Individualised_consideration_sum,    
    
        /* ── Transactional Subscales ── */    
        CAST(ROUND(SUM(CASE WHEN e.questionid IN (2,11,16,35) THEN m.marks ELSE 0 END) / 4.0, 2) AS DECIMAL(10,2)) AS Contingent_Reward,    
        SUM(CASE WHEN e.questionid IN (2,11,16,35) THEN m.marks ELSE 0 END) AS Contingent_Reward_sum,    
    
        CAST(ROUND(SUM(CASE WHEN e.questionid IN (4,22,24,27) THEN m.marks ELSE 0 END) / 4.0, 2) AS DECIMAL(10,2)) AS Management_by_exception_Active,    
        SUM(CASE WHEN e.questionid IN (4,22,24,27) THEN m.marks ELSE 0 END) AS Management_by_exception_Active_sum,    
    
        CAST(ROUND(SUM(CASE WHEN e.questionid IN (3,12,17,20) THEN m.marks ELSE 0 END) / 4.0, 2) AS DECIMAL(10,2)) AS Management_by_exception_passive,    
        SUM(CASE WHEN e.questionid IN (3,12,17,20) THEN m.marks ELSE 0 END) AS Management_by_exception_passive_sum,    
    
        /* ── Laissez-Faire ── */    
        CAST(ROUND(SUM(CASE WHEN e.questionid IN (5,7,28,33) THEN m.marks ELSE 0 END) / 4.0, 2) AS DECIMAL(10,2)) AS Laissez_Faire,    
        SUM(CASE WHEN e.questionid IN (5,7,28,33) THEN m.marks ELSE 0 END) AS Laissez_Faire_sum,    
    
        /* ── Main Scores ── */    
        CAST(ROUND(SUM(CASE WHEN e.questionid IN (10,18,21,25,6,14,23,34,9,13,26,36,2,8,30,32,15,19,29,31) THEN m.marks ELSE 0 END) / 20.0, 2) AS DECIMAL(10,2)) AS Transformational_Leadership,    
        CAST(ROUND(SUM(CASE WHEN e.questionid IN (10,18,21,25,6,14,23,34,9,13,26,36,2,8,30,32,15,19,29,31) THEN m.marks ELSE 0 END) / 5.0, 2) AS DECIMAL(10,2)) AS Transformational_Leadership_sum,    
    
        CAST(ROUND(SUM(CASE WHEN e.questionid IN (2,11,16,35,4,22,24,27,3,12,17,20) THEN m.marks ELSE 0 END) / 12.0, 2) AS DECIMAL(10,2)) AS Transactional_Leadership,    
        CAST(ROUND(SUM(CASE WHEN e.questionid IN (2,11,16,35,4,22,24,27,3,12,17,20) THEN m.marks ELSE 0 END) / 3.0, 2) AS DECIMAL(10,2)) AS Transactional_Leadership_sum    
    
    FROM TBL_MLQ_empdtls e    
    INNER JOIN TBL_MLQ_ansmarks m    
        ON e.questionid = m.questionno    
       AND e.answer    = m.answerno    
    WHERE e.CandidateID = @candidateid;    
END    
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: trecruitcanbasicdtls, trecruitconflictexamdtls */
/****** Object:  StoredProcedure [dbo].[Proc_updateConflictcmt]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure  [dbo].[Proc_updateConflictcmt]             
@comment  nvarchar(max),            
@registrationno varchar(100) ,          
@examno int          
AS             
BEGIN          
  Declare @candidateid bigint        
  select @candidateid = candidateid from trecruitcanbasicdtls where registrationnumber = @registrationno        
        
  if(@examno = 1)          
  begin          
 update trecruitconflictexamdtls set Comment=@comment where candidateid=@candidateid and attemexam=@examno          
  end          
  else           
 update trecruitconflictexamdtls set Comment=@comment where candidateid=@candidateid and attemexam=@examno         
END
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: trecruitcanbasicdtls, trecruitdiscrolexamdtls */
/****** Object:  StoredProcedure [dbo].[Proc_updatediscrolcmt]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure  [dbo].[Proc_updatediscrolcmt]             
@comment  nvarchar(max),            
@registrationno varchar(100) ,          
@examno int          
AS             
BEGIN          
  Declare @candidateid bigint        
  select @candidateid = candidateid from trecruitcanbasicdtls where registrationnumber = @registrationno        
        
  if(@examno = 1)          
  begin          
 update trecruitdiscrolexamdtls set Comment=@comment where candidateid=@candidateid and attemexam=@examno          
  end          
  else           
 update trecruitdiscrolexamdtls set Comment=@comment where candidateid=@candidateid and attemexam=@examno         
END
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: trecruitcanbasicdtls, trecruiteqexamdtls */
/****** Object:  StoredProcedure [dbo].[Proc_updateEqcmt]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure  [dbo].[Proc_updateEqcmt]                   
@comment nvarchar(max),                  
@registrationnumber varchar(100) ,                
@examno int                
AS                   
BEGIN                
  Declare @candidateid bigint              
  select @candidateid = candidateid from trecruitcanbasicdtls where registrationnumber = @registrationnumber            
              
  if(@examno = 1)                
  begin                
 update trecruiteqexamdtls set Comment=@comment where candidateid=@candidateid and attemexam=@examno                
  end                
  else                 
 update trecruiteqexamdtls set Comment=@comment where candidateid=@candidateid and attemexam=@examno               
END
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: trecruitcanbasicdtls, trecruitiqexamdtls */
/****** Object:  StoredProcedure [dbo].[Proc_updateIQcmt]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure  [dbo].[Proc_updateIQcmt]               
@comment  nvarchar(max),              
@registrationno varchar(100) ,            
@examno int            
AS               
BEGIN            
  Declare @candidateid bigint          
  select @candidateid = candidateid from trecruitcanbasicdtls where registrationnumber = @registrationno          
          
  if(@examno = 1)            
  begin            
 update trecruitiqexamdtls set Comment=@comment where candidateid=@candidateid and attemexam=@examno            
  end            
  else             
 update trecruitiqexamdtls set Comment=@comment where candidateid=@candidateid and attemexam=@examno           
END
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: trecruitbigfiveexamdtls, trecruitcanbasicdtls, trecruittraker */
/****** Object:  StoredProcedure [dbo].[procbigfivehrdtls]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[procbigfivehrdtls]
@candidateattemexam INT=NULL, 
@registrationnumber VARCHAR(200)=NULL,
@action varchar(200),
@Message            VARCHAR(200)=NULL 
as
declare @candidateid int
declare @canbigfuveallow varchar(100)
begin
SELECT @candidateid = candidateid 
      FROM   [dbo].[trecruitcanbasicdtls] 
      WHERE  registrationnumber = @registrationnumber 
IF @action = 'SELECTEXAMNO' 
        BEGIN 
            SELECT [attemexam], 
                   CASE 
                     WHEN [attemexam] = 1 THEN Cast('1st Exam' AS VARCHAR) 
                     WHEN [attemexam] = 2 THEN Cast('2nd Exam'AS VARCHAR) 
                     WHEN [attemexam] = 3 THEN Cast('3rd Exam'AS VARCHAR) 
                     ELSE Cast([attemexam]AS VARCHAR) + '' + 'th Exam' 
                   END [attemexamtext] 
            FROM   [dbo].[trecruitbigfiveexamdtls] 
            WHERE  candidateid = @candidateid 
                   AND finalsubmit = 'Yes' 
            ORDER  BY [attemexam] 
        END 
 IF @action = 'Activeinactiveresbutton' 
        BEGIN 
            SELECT 
                   a.[bigfiveallow] 
            FROM   [dbo].[trecruitcanbasicdtls] a                
            WHERE a.candidateid = @candidateid 
        END 
  IF @action = 'Reschedule' 
        BEGIN 
            --SELECT @candiscrolallow = [discrolallow] 
            --FROM   [dbo].[trecruittraker] 
            --WHERE  [candidateid] = @candidateid 
            --GROUP  BY [discrolallow], 
            --          [conflictallow], 
            --          [iqallow], 
            --          [eqallow] 

			SELECT @canbigfuveallow = [bigfiveallow] 
            FROM   [dbo].[trecruitcanbasicdtls]
            WHERE  [candidateid] = @candidateid 
            --GROUP  BY [discrolallow], 
            --          [conflictallow], 
            --          [iqallow], 
            --          [eqallow] 

             
            IF @canbigfuveallow = 'Completed' 
              BEGIN 
                  UPDATE [dbo].[trecruitcanbasicdtls] 
                  SET    [bigfiveallow] = 'Reschedule' 
                  WHERE  [candidateid] = @candidateid 
              END 
            ELSE 
              BEGIN 
                  SET @message=1 
              END 
        END 
end
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: trecruitbigfivecandidatedtls, trecruitbigfivecanlanguagemapping, trecruitbigfiveexamdtls, trecruitbigfivequestiondtls, trecruitcanbasicdtls, trecruitcandidatesignup, trecruitconflictexamdtls, trecruitdiscrolexamdtls, trecruittraker */
/****** Object:  StoredProcedure [dbo].[procbigfivemasdtls]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[procbigfivemasdtls]
@username varchar(Max),
@action varchar(Max),
@questiondtlsid   INT=NULL,
@number int=null,
@quesserialnonext int=null,
@message VARCHAR(500)=NULL output 
as
declare @candidateid int
declare @maplanid int
declare @countexamques int
declare @attemptno int
declare @quesserialno int
declare @findques int
declare @countexamattm int
declare @countexamattmcan int
declare @countexamattques int
declare @atteptestno int
begin
SELECT @candidateid = candidateid 
      FROM   [dbo].[trecruitcandidatesignup] 
      WHERE  [username] = @username 
SELECT @maplanid = languageid 
            FROM   [dbo].[trecruitbigfivecanlanguagemapping] 
            WHERE  candidateid = @candidateid 
SELECT @quesserialno = Min(questionserialno) 
      FROM   [dbo].[trecruitbigfivequestiondtls] 
      WHERE  languageid = @maplanid 
             AND deleteflag = 'No' 
sELECT @findques = Count(questionserialno) 
      FROM   [dbo].[trecruitbigfivecandidatedtls] 
      WHERE  candidateid = @candidateid 
             AND questionserialno = @questiondtlsid 
             AND [quesfinalsubmit] IS NULL 

if(@action ='bigfivecandidatelanguagemap')
begin
 DELETE FROM [dbo].[trecruitbigfivecanlanguagemapping] 
            WHERE  [candidateid] = @candidateid 

            INSERT INTO [dbo].[trecruitbigfivecanlanguagemapping] 
                        ([candidateid], 
                         [languageid]) 
            VALUES      (@candidateid, 
                         5 ) 
SELECT @maplanid = languageid 
            FROM   [dbo].[trecruitbigfivecanlanguagemapping] 
            WHERE  candidateid = @candidateid 
 SELECT @countexamques = Count([questionserialno]) 
            FROM   [dbo].[trecruitbigfivequestiondtls] 
            WHERE  [languageid] = @maplanid 
SELECT @attemptno = Count([attemexam]) 
            FROM   [dbo].[trecruitbigfiveexamdtls] 
            WHERE  [finalsubmit] = 'Yes' 
                   AND candidateid = @candidateid 

DELETE FROM [dbo].[trecruitbigfivecandidatedtls] 
            WHERE [quesfinalsubmit]  IS NULL 
                   AND candidateid = @candidateid 

DELETE FROM [dbo].[trecruitbigfiveexamdtls] 
            WHERE  [finalsubmit] = 'No' 
            AND candidateid = @candidateid 
INSERT INTO [dbo].[trecruitbigfiveexamdtls] 
                        ([candidateid], 
                         [languageid], 
                         [totalques], 
                         [attemques], 
                         [finalsubmit], 
                         [attemexam]) 
            VALUES      ( @candidateid, 
                          @maplanid, 
                          @countexamques, 
                          NULL, 
                          'No', 
                          @attemptno + 1 )

end
if @action='bigfivequesansselect'
begin
SELECT previousvalue, 
                   previousvalueques, 
                   questionserialno, 
                   question, 
                   nextvalue, 
                   nextvalueques, 
                   noofques 
            FROM   (SELECT Lag(p.questionserialno) 
                             OVER ( 
                               ORDER BY p.[id]) PreviousValue, 
                           Lag(p.question) 
                             OVER ( 
                               ORDER BY p.[id]) PreviousValueques, 
                           p.questionserialno, 
                           p.question, 
                           Lead(p.questionserialno) 
                             OVER ( 
                               ORDER BY p.[id]) NextValue, 
                           Lead(p.question) 
                             OVER ( 
                               ORDER BY p.[id]) NextValueques, 
                           languageid 
                    FROM   [dbo].[trecruitbigfivequestiondtls] p 
                    WHERE  languageid = @maplanid 
                           AND deleteflag = 'No')s, 
                   (SELECT languageid, 
                           Count([question])noofques 
                    FROM   [dbo].[trecruitbigfivequestiondtls] 
                    WHERE  languageid = @maplanid 
                           AND deleteflag = 'No' 
                    GROUP  BY languageid) p 
            WHERE  questionserialno = @quesserialno 
                   AND p.languageid = s.languageid 
end
 IF @action = 'bigfivequesansselectnext' 
        BEGIN 
		
            SELECT previousvalue, 
                   previousvalueques, 
                   s.questionserialno, 
                   question, 
                   nextvalue, 
                   nextvalueques, 
                   noofques, 
                   CASE 
                     WHEN x.candidateid IS NULL THEN 0 
                     ELSE x.candidateid 
                   END candidateid, 
                   CASE 
                     WHEN x.[answer] IS NULL THEN 0 
                     ELSE x.[answer] 
                   END answer, 
                   CASE 
                     WHEN y.[attemques] BETWEEN 1 AND 100 THEN y.[attemques] 
                     ELSE y.[attemques] 
                   END [attemques] 
            FROM   (SELECT Lag(p.questionserialno) 
                             OVER ( 
                               ORDER BY p.[id]) PreviousValue, 
                           Lag(p.question) 
                             OVER ( 
                               ORDER BY p.[id]) PreviousValueques, 
                           p.questionserialno, 
                           p.question, 
                           Lead(p.questionserialno) 
                             OVER ( 
                               ORDER BY p.[id]) NextValue, 
                           Lead(p.question) 
                             OVER ( 
                               ORDER BY p.[id]) NextValueques, 
                           languageid 
                    FROM   [dbo].[trecruitbigfivequestiondtls] p 
                    WHERE  languageid = 5 
                           AND deleteflag = 'No')s 
                   LEFT OUTER JOIN 
                   [dbo].[trecruitbigfivecandidatedtls] 
                   x 
                                ON s.languageid = x.[languageid] 
                                   AND s.questionserialno = x.[questionserialno] 
                                   AND [quesfinalsubmit]  IS NULL 
                                   AND x.[candidateid] = @candidateid, 
                   (SELECT languageid, 
                           Count([question])noofques 
                    FROM   [dbo].[trecruitbigfivequestiondtls] 
                    WHERE  languageid = @maplanid 
                           AND deleteflag = 'No' 
                    GROUP  BY languageid) p, 
                   [dbo].[trecruitbigfiveexamdtls] y 
            WHERE  s.questionserialno= @quesserialnonext 
                   AND p.languageid = s.languageid 
                   AND s.languageid = y.[languageid] 
                   AND y.[candidateid] = @candidateid 
                   AND [finalsubmit] <> 'Yes' 
        END 

IF @action = 'bigfivecandtlsinsert' 
         AND @findques = 0 
        BEGIN 
            SELECT @countexamattm = [attemexam] 
            FROM   [dbo].[trecruitbigfiveexamdtls] 
            WHERE  [candidateid] = @candidateid 
                   AND finalsubmit <> 'Yes' 

            SELECT @countexamattmcan = Count([candidateid]) 
            FROM   [dbo].[trecruitbigfiveexamdtls] 
            WHERE  [candidateid] = @candidateid 

            BEGIN 
                INSERT INTO [dbo].[trecruitbigfivecandidatedtls] 
                            ([candidateid], 
                             [languageid], 
                             [questionserialno], 
                             [answer], 
                             candidateattemexam, 
                             [createdon], 
                             [updatedon]) 
                VALUES      ( @candidateid, 
                              @maplanid, 
                              @questiondtlsid, 
                              @number, 
                              @countexamattm, 
                              Getdate(), 
                              Getdate() ) 

                SET @message='Answer Details Successfully Inserted' 
            END 

            SELECT @countexamattques = Count([questionserialno]) 
            FROM   [dbo].[trecruitbigfivecandidatedtls] 
            WHERE  candidateid = @candidateid 
                   AND answer <> 0 
                   AND quesfinalsubmit IS NULL 

            IF @countexamattm IS NOT NULL 
              BEGIN 
                  UPDATE [dbo].[trecruitbigfiveexamdtls] 
                  SET    [attemques] = [totalques] - @countexamattques 
                  WHERE  candidateid = @candidateid 
                         AND finalsubmit <> 'Yes' 
              END 
        END 
 IF @action = 'bigfivecandtlsinsert' 
         AND @findques > 0 
        BEGIN 
            SELECT @countexamattm = [attemexam] 
            FROM   [dbo].[trecruitbigfiveexamdtls] 
            WHERE  [candidateid] = @candidateid 
                   AND finalsubmit <> 'Yes' 

            UPDATE [dbo].[trecruitbigfivecandidatedtls] 
            SET    [answer] = @number, 
                   [updatedon] = Getdate() 
            WHERE  [candidateid] = @candidateid 
                   AND [questionserialno] = @questiondtlsid 
                   AND [quesfinalsubmit] IS NULL 

            SET @message='Answer Details Successfully Updated' 

            SELECT @countexamattques = Count([questionserialno]) 
            FROM   [dbo].[trecruitbigfivecandidatedtls] 
            WHERE  candidateid = @candidateid 
                   AND answer <> 0 
                   AND quesfinalsubmit IS NULL 

            IF @countexamattm IS NOT NULL 
              BEGIN 
                  UPDATE [dbo].[trecruitbigfiveexamdtls] 
                  SET    [attemques] = [totalques] - @countexamattques 
                  WHERE  candidateid = @candidateid 
                         AND finalsubmit <> 'Yes' 
              END 
        END 
 IF @action = 'bigfiveansqnoselect' 
        BEGIN 
            SELECT @atteptestno = [attemexam] 
            FROM   [dbo].[trecruitbigfiveexamdtls] 
            WHERE  [finalsubmit] <> 'Yes' 
                   AND [candidateid] = @candidateid 

            SELECT [questionserialno] 
            FROM   [dbo].[trecruitbigfivecandidatedtls] 
            WHERE  [answer] > 0 
                   AND [candidateattemexam] = @atteptestno 
                   AND [candidateid] = @candidateid 
        END 
  IF @action = 'Finalsubmit' 
        BEGIN 
            UPDATE [dbo].[trecruitbigfiveexamdtls] 
            SET    [finalsubmit] = 'Yes' 
            WHERE  candidateid = @candidateid 

            --UPDATE [dbo].[trecruittraker] 
            --SET    [conflictallow] = 'Completed' 
            --WHERE  candidateid = @candidateid 

			---------------------------------------
			UPDATE [dbo].[trecruitcanbasicdtls] 
            SET    [bigfiveallow] = 'Completed' 
            WHERE  candidateid = @candidateid 
			-------------------------------------------

            UPDATE [dbo].[trecruitbigfivecandidatedtls] 
            SET    [quesfinalsubmit] = 'F' 
            WHERE  candidateid = @candidateid 

		

	--		select @discrolfinalsubmit=[finalsubmit],@discrolattemexam=[attemexam]
	--		 from [dbo].[trecruitdiscrolexamdtls]
	--		where [candidateid]=@candidateid 

	--		select @conflictfinalsubmit=[finalsubmit],@conflictattemexam=[attemexam]
	--		 from [dbo].[trecruitconflictexamdtls]
	--		where [candidateid]=@candidateid 

	--		if @discrolfinalsubmit='Yes' and @conflictfinalsubmit='Yes'
	--		and @discrolattemexam<2 and @conflictattemexam<2
	--		begin


 --  SELECT @MailId=[MailId]      
 -- FROM [dbo].[trecruitcandidatesignup]
 -- where candidateid=@candidateid

	--EXEC msdb.dbo.sp_send_dbmail
 --   @profile_name = 'Mendine2_Email_Profile'
 --  ,@recipients = @MailId
 --  ,@subject = 'Email from SQL Server'
 --  ,@body = 'This is my First Email sent from SQL Server :)'
 --  ,@importance ='HIGH'
	--		end
        END 
end
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: trecruitbigfivecandidatedtls, trecruitcanbasicdtls */
/****** Object:  StoredProcedure [dbo].[procbigfiveresult]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[procbigfiveresult]
@candidateattemexam INT=NULL,
@registrationnumber VARCHAR(200)=NULL
as
declare @candidateid int 
declare @Extraversion int
declare @Agreeableness int
declare @Conscientiousness int
declare @Neuroticism int
declare @OpennesstoExperience int
declare @firstpart int
declare @lastpart int
begin
SELECT @candidateid = candidateid 
      FROM   [dbo].[trecruitcanbasicdtls] 
      WHERE  registrationnumber = @registrationnumber 

------for  Extraversion-------------
Select @firstpart=sum(answer) from trecruitbigfivecandidatedtls 
where candidateid=@candidateid
and candidateattemexam=@candidateattemexam
and questionserialno in(1,11,21,31,41)

Select @lastpart=sum(answer) from trecruitbigfivecandidatedtls 
where candidateid=@candidateid
and candidateattemexam=@candidateattemexam
and questionserialno in(6,16,26,36,46)
set @Extraversion=(20+@firstpart)-@lastpart
set @firstpart=0
set @lastpart=0
--------for Agreeableness------------------
Select @firstpart=sum(answer) from trecruitbigfivecandidatedtls 
where candidateid=@candidateid
and candidateattemexam=@candidateattemexam
and questionserialno in(7,17,27,37,47,42)

Select @lastpart=sum(answer) from trecruitbigfivecandidatedtls 
where candidateid=@candidateid
and candidateattemexam=@candidateattemexam
and questionserialno in(2,12,22,32)
set @Agreeableness=(14+@firstpart)-@lastpart
set @firstpart=0
set @lastpart=0
--------for Conscientiousness------------------
Select @firstpart=sum(answer) from trecruitbigfivecandidatedtls 
where candidateid=@candidateid
and candidateattemexam=@candidateattemexam
and questionserialno in(3,13,23,33,43,48)

Select @lastpart=sum(answer) from trecruitbigfivecandidatedtls 
where candidateid=@candidateid
and candidateattemexam=@candidateattemexam
and questionserialno in(8,18,28,38)
set @Conscientiousness=(14+@firstpart)-@lastpart
set @firstpart=0
set @lastpart=0
--------for Neuroticism------------------
Select @firstpart=sum(answer) from trecruitbigfivecandidatedtls 
where candidateid=@candidateid
and candidateattemexam=@candidateattemexam
and questionserialno in(9,19)

Select @lastpart=sum(answer) from trecruitbigfivecandidatedtls 
where candidateid=@candidateid
and candidateattemexam=@candidateattemexam
and questionserialno in(4,14,24,29,34,39,44,49)
set @Neuroticism=(38+@firstpart)-@lastpart
set @firstpart=0
set @lastpart=0
--------for OpennesstoExperience------------------
Select @firstpart=sum(answer) from trecruitbigfivecandidatedtls 
where candidateid=@candidateid
and candidateattemexam=@candidateattemexam
and questionserialno in(5,15,25,35,40,45,50)

Select @lastpart=sum(answer) from trecruitbigfivecandidatedtls 
where candidateid=@candidateid
and candidateattemexam=@candidateattemexam
and questionserialno in(10,20,30)
set @OpennesstoExperience=(8+@firstpart)-@lastpart
set @firstpart=0
set @lastpart=0
------------------------------------
--Select @Extraversion Extraversion,
--       @Agreeableness Agreeableness,
--	   @Conscientiousness Conscientiousness,
--	   @Neuroticism Neuroticism,
--	   @OpennesstoExperience OpennesstoExperience

Select 'Extraversion' itype,@Extraversion ivalue
union
Select 'Agreeableness' itype,@Agreeableness ivalue
union
Select 'Conscientiousness' itype,@Conscientiousness ivalue
union
Select 'Neuroticism' itype,@Neuroticism ivalue
union
Select 'Openness to Experience' itype,@OpennesstoExperience ivalue

end
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: Languages, trecruitcanbasicdtls, trecruitconflictansdtls, trecruitconflictcandidatedtls, trecruitconflictquestype, trecruitconflictqusdtls */
/****** Object:  StoredProcedure [dbo].[procconaccmmodatescore]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[procconaccmmodatescore]
@candidateattemexam INT=NULL, 
 @registrationnumber VARCHAR(200)=NULL 
as
 DECLARE @candidateid INT 
begin
 SELECT @candidateid = candidateid 
      FROM   [dbo].[trecruitcanbasicdtls] 
      WHERE  registrationnumber = @registrationnumber 
SELECT 
                           a.questionid, 
                           a.answer
                    FROM   [dbo].[trecruitconflictcandidatedtls] a, 
                           [dbo].[trecruitconflictqusdtls] b, 
                           [dbo].[trecruitconflictquestype] c, 
                           [dbo].[trecruitconflictansdtls]f, 
                           [dbo].[trecruitcanbasicdtls] d, 
                           [dbo].[languages]e 
                    WHERE  a.[languageid] = b.[languageid] 
                           AND a.[questionid] = b.[quesserialno] 
                           AND b.[conquestypeid] = c.[id] 
                           AND a.[candidateid] = d.[candidateid] 
                           AND a.[languageid] = e.[id] 
                           AND a.answer = f.[number]
						   and a.[languageid]=f.[languageid]                            
                           AND [candidateattemexam] = @candidateattemexam
                           AND c.[id] = 3
						   and a.candidateid=@candidateid
end




GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: Languages, trecruitcanbasicdtls, trecruitconflictansdtls, trecruitconflictcandidatedtls, trecruitconflictquestype, trecruitconflictqusdtls */
/****** Object:  StoredProcedure [dbo].[procconavoidscore]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[procconavoidscore]
@candidateattemexam INT=NULL, 
 @registrationnumber VARCHAR(200)=NULL 
as
 DECLARE @candidateid INT 
begin
 SELECT @candidateid = candidateid 
      FROM   [dbo].[trecruitcanbasicdtls] 
      WHERE  registrationnumber = @registrationnumber 
SELECT 
                           a.questionid, 
                           a.answer
                    FROM   [dbo].[trecruitconflictcandidatedtls] a, 
                           [dbo].[trecruitconflictqusdtls] b, 
                           [dbo].[trecruitconflictquestype] c, 
                           [dbo].[trecruitconflictansdtls]f, 
                           [dbo].[trecruitcanbasicdtls] d, 
                           [dbo].[languages]e 
                    WHERE  a.[languageid] = b.[languageid] 
                           AND a.[questionid] = b.[quesserialno] 
                           AND b.[conquestypeid] = c.[id] 
                           AND a.[candidateid] = d.[candidateid] 
                           AND a.[languageid] = e.[id] 
                           AND a.answer = f.[number]
						   and a.[languageid]=f.[languageid]                            
                           AND [candidateattemexam] = @candidateattemexam
                           AND c.[id] = 1 
						   and a.candidateid=@candidateid
end




GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: trecruitcanbasicdtls, trecruitotherpost */
/****** Object:  StoredProcedure [dbo].[procconcandidatenamepost]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
CREATE proc [dbo].[procconcandidatenamepost]    
     
                                 @registrationnumber VARCHAR(200)=NULL   
								-- @action Varchar(100)=NULL
as    
DECLARE @candidateid INT     
begin    
    
SELECT @candidateid = candidateid     
      FROM   [dbo].[trecruitcanbasicdtls]     
      WHERE  registrationnumber = @registrationnumber     
    
--SELECT a.[firstname] + ' ' + a.[middlename] + ' '     
--                   + a.[lastname] CandidateName,     
--                   b.position postname     
                        
--            FROM   [dbo].[trecruitcanbasicdtls] a, [dbo].[vw_canapppost] b                       
--            WHERE  a.candidateid = b.candidateid     
--                   AND a.candidateid = @candidateid    
--       union    
--        SELECT a.[firstname] + ' ' + a.[middlename] + ' '     
--                   + a.[lastname] CandidateName,     
--                   b.[otpostname] postname     
                        
--            FROM   [dbo].[trecruitcanbasicdtls] a, [dbo].[trecruitotherpost] b                       
--            WHERE  a.candidateid = b.candidateid     
--                   AND a.candidateid = @candidateid    

	
	--IF @action = 'Activeinactiveresbutton'       
 --       BEGIN
		 
            SELECT       
                   a.firstname+' '+a.middlename+' '+a.lastname CandidateName,      
       b.position as postname,Isnull (a.[conflictallow],'') conflictallow       
         FROM   [dbo].[trecruitcanbasicdtls] a  ,[vw_canapppost] b                    
            WHERE   a.candidateid = @candidateid     
   and a.candidateid=b.candidateid     
   union
       SELECT a.[firstname] + ' ' + a.[middlename] + ' '     
                   + a.[lastname] CandidateName,     
                   b.[otpostname] postname  ,   Isnull (a.[conflictallow],'') conflictallow  
                        
            FROM   [dbo].[trecruitcanbasicdtls] a, [dbo].[trecruitotherpost] b                       
            WHERE  a.candidateid = b.candidateid     
                   AND a.candidateid = @candidateid    
   
        --END   
    
       end 
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: Languages, trecruitcanbasicdtls, trecruitconflictansdtls, trecruitconflictcandidatedtls, trecruitconflictquestype, trecruitconflictqusdtls */
/****** Object:  StoredProcedure [dbo].[procconcollaboratescore]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[procconcollaboratescore]
@candidateattemexam INT=NULL, 
 @registrationnumber VARCHAR(200)=NULL 
as
 DECLARE @candidateid INT 
begin
 SELECT @candidateid = candidateid 
      FROM   [dbo].[trecruitcanbasicdtls] 
      WHERE  registrationnumber = @registrationnumber 
SELECT 
                           a.questionid, 
                           a.answer
                    FROM   [dbo].[trecruitconflictcandidatedtls] a, 
                           [dbo].[trecruitconflictqusdtls] b, 
                           [dbo].[trecruitconflictquestype] c, 
                           [dbo].[trecruitconflictansdtls]f, 
                           [dbo].[trecruitcanbasicdtls] d, 
                           [dbo].[languages]e 
                    WHERE  a.[languageid] = b.[languageid] 
                           AND a.[questionid] = b.[quesserialno] 
                           AND b.[conquestypeid] = c.[id] 
                           AND a.[candidateid] = d.[candidateid] 
                           AND a.[languageid] = e.[id] 
                           AND a.answer = f.[number]
						   and a.[languageid]=f.[languageid]                            
                           AND [candidateattemexam] = @candidateattemexam
                           AND c.[id] = 5
						   and a.candidateid=@candidateid
end




GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: Languages, trecruitcanbasicdtls, trecruitconflictansdtls, trecruitconflictcandidatedtls, trecruitconflictquestype, trecruitconflictqusdtls */
/****** Object:  StoredProcedure [dbo].[procconcompletescore]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[procconcompletescore]
@candidateattemexam INT=NULL, 
 @registrationnumber VARCHAR(200)=NULL 
as
 DECLARE @candidateid INT 
begin
 SELECT @candidateid = candidateid 
      FROM   [dbo].[trecruitcanbasicdtls] 
      WHERE  registrationnumber = @registrationnumber 
SELECT 
                           a.questionid, 
                           a.answer
                    FROM   [dbo].[trecruitconflictcandidatedtls] a, 
                           [dbo].[trecruitconflictqusdtls] b, 
                           [dbo].[trecruitconflictquestype] c, 
                           [dbo].[trecruitconflictansdtls]f, 
                           [dbo].[trecruitcanbasicdtls] d, 
                           [dbo].[languages]e 
                    WHERE  a.[languageid] = b.[languageid] 
                           AND a.[questionid] = b.[quesserialno] 
                           AND b.[conquestypeid] = c.[id] 
                           AND a.[candidateid] = d.[candidateid] 
                           AND a.[languageid] = e.[id] 
                           AND a.answer = f.[number]
						   and a.[languageid]=f.[languageid]                            
                           AND [candidateattemexam] = @candidateattemexam
                           AND c.[id] = 2
						   and a.candidateid=@candidateid
end




GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: Languages, trecruitcanbasicdtls, trecruitconflictansdtls, trecruitconflictcandidatedtls, trecruitconflictquestype, trecruitconflictqusdtls */
/****** Object:  StoredProcedure [dbo].[procconcomprisescore]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[procconcomprisescore]
@candidateattemexam INT=NULL, 
 @registrationnumber VARCHAR(200)=NULL 
as
 DECLARE @candidateid INT 
begin
 SELECT @candidateid = candidateid 
      FROM   [dbo].[trecruitcanbasicdtls] 
      WHERE  registrationnumber = @registrationnumber 
SELECT 
                           a.questionid, 
                           a.answer
                    FROM   [dbo].[trecruitconflictcandidatedtls] a, 
                           [dbo].[trecruitconflictqusdtls] b, 
                           [dbo].[trecruitconflictquestype] c, 
                           [dbo].[trecruitconflictansdtls]f, 
                           [dbo].[trecruitcanbasicdtls] d, 
                           [dbo].[languages]e 
                    WHERE  a.[languageid] = b.[languageid] 
                           AND a.[questionid] = b.[quesserialno] 
                           AND b.[conquestypeid] = c.[id] 
                           AND a.[candidateid] = d.[candidateid] 
                           AND a.[languageid] = e.[id] 
                           AND a.answer = f.[number]
						   and a.[languageid]=f.[languageid]                            
                           AND [candidateattemexam] = @candidateattemexam
                           AND c.[id] = 4
						   and a.candidateid=@candidateid
end




GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: Languages, trecruitcanbasicdtls, trecruitconflictansdtls, trecruitconflictcandidatedtls, trecruitconflictexamdtls, trecruitconflictquestype, trecruitconflictqusdtls, trecruittraker, trecuitpsycycotesttype */
/****** Object:  StoredProcedure [dbo].[procconflicthrdtls]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Script for SelectTopNRows command from SSMS  ******/ 
CREATE PROC [dbo].[procconflicthrdtls] @action             VARCHAR(100)=NULL, 
                                 @phytypeid          INT=NULL, 
                                 @postname           VARCHAR(500)=NULL, 
                                 @deptname           VARCHAR(500)=NULL, 
                                 @candidateattemexam INT=NULL, 
                                 @registrationnumber VARCHAR(200)=NULL, 
                                 @discrolallow       VARCHAR(200)=NULL, 
                                 @Message            VARCHAR(200)=NULL 
AS 
    DECLARE @candidateid INT 
    DECLARE @candiscrolallow VARCHAR(200) 
	DECLARE @canconflictallow VARCHAR(200) 

  BEGIN 
      SELECT @candidateid = candidateid 
      FROM   [dbo].[trecruitcanbasicdtls] 
      WHERE  registrationnumber = @registrationnumber 

      IF @action = 'Selecttypewisecandidate' 
        BEGIN 
            --IF @deptname = 'SALES' 
            --  BEGIN 
            --      SET @deptname='SALES(PHOENIX)' 
            --  END 

            SELECT [referenceno], 
                   [candidatename], 
                   [typename] 
            FROM   (SELECT [referenceno], 
                           [candidatename], 
                           CASE 
                             WHEN discrolallow = 'Completed' THEN 1 
                             WHEN discrolallow = 'Reschedule' THEN 1 
                             ELSE discrolallow 
                           END discrolallow, 
                           CASE 
                             WHEN conflictallow = 'Completed' THEN 2 
                             WHEN conflictallow = 'Reschedule' THEN 2 
                             ELSE conflictallow 
                           END conflictallow, 
                           CASE 
                             WHEN iqallow = 'Completed' THEN 3 
                             WHEN iqallow = 'Reschedule' THEN 3 
                             ELSE iqallow 
                           END iqallow, 
                           CASE 
                             WHEN eqallow = 'Completed' THEN 4 
                             WHEN eqallow = 'Reschedule' THEN 4 
                             ELSE eqallow 
                           END eqallow 
                    FROM   [dbo].[trecruittraker] 
                    WHERE  postname = @postname 
                           AND departmentdivision = @deptname 
                           AND discrolallow IN ( 'Completed', 'Reschedule' ) 
                            OR conflictallow IN ( 'Completed', 'Reschedule' ) 
                            OR iqallow IN ( 'Completed', 'Reschedule' ) 
                            OR eqallow IN ( 'Completed', 'Reschedule' )) a, 
                   [dbo].[trecuitpsycycotesttype] b 
            WHERE  a.discrolallow = Cast(b.[id] AS VARCHAR) 
                   AND b.id = @phytypeid 
        END 

      IF @action = 'Selecttypewiseotcandidate' 
        BEGIN 
            SELECT [referenceno], 
                   [candidatename], 
                   [typename] 
            FROM   (SELECT [referenceno], 
                           [candidatename], 
                           CASE 
                             WHEN discrolallow = 'Completed' THEN 1 
                             WHEN discrolallow = 'Reschedule' THEN 1 
                             ELSE discrolallow 
                           END discrolallow, 
                           CASE 
                             WHEN conflictallow = 'Completed' THEN 2 
                             WHEN conflictallow = 'Reschedule' THEN 2 
                             ELSE conflictallow 
                           END conflictallow, 
                           CASE 
                             WHEN iqallow = 'Completed' THEN 3 
                             WHEN iqallow = 'Reschedule' THEN 3 
                             ELSE iqallow 
                           END iqallow, 
                           CASE 
                             WHEN eqallow = 'Completed' THEN 4 
                             WHEN eqallow = 'Reschedule' THEN 4 
                             ELSE eqallow 
                           END eqallow 
                    FROM   [dbo].[trecruittraker] 
                    WHERE  departmentdivision = '' 
                           AND discrolallow IN ( 'Completed', 'Reschedule' ) 
                            OR conflictallow IN ( 'Completed', 'Reschedule' ) 
                            OR iqallow IN ( 'Completed', 'Reschedule' ) 
                            OR eqallow IN ( 'Completed', 'Reschedule' )) a, 
                   [dbo].[trecuitpsycycotesttype] b 
            WHERE  discrolallow = Cast([id] AS VARCHAR) 
                   AND id = @phytypeid 
        END 

      IF @action = 'Selectquesans' 
        BEGIN 
            SELECT [conquestype], 
                   [quesserialno], 
                   [question], 
                   f.[answer] 
            FROM   [dbo].[trecruitconflictcandidatedtls] a, 
                   [dbo].[trecruitconflictqusdtls] b, 
                   [dbo].[trecruitconflictquestype] c, 
                   [dbo].[trecruitconflictansdtls]f, 
                   [dbo].[trecruitcanbasicdtls] d, 
                   [dbo].[languages]e 
            WHERE  a.[languageid] = b.[languageid] 
                   AND a.[questionid] = b.[quesserialno] 
                   AND b.[conquestypeid] = c.[id] 
                   AND a.[candidateid] = d.[candidateid] 
                   AND a.[languageid] = e.[id] 
                   AND a.answer = f.number 
                   AND a.[languageid] = f.[languageid] 
                   AND a.candidateid = @candidateid 
                   AND [candidateattemexam] = @candidateattemexam 
            ORDER  BY [quesserialno] 
        END 

      IF @action = 'Reschedule' 
        BEGIN 
            SELECT @canconflictallow = [conflictallow] 
            FROM   [dbo].[trecruitcanbasicdtls]
            WHERE  [candidateid] = @candidateid 
            GROUP  BY [discrolallow], 
                      [conflictallow], 
                      [iqallow], 
                      [eqallow]  

            IF @canconflictallow = 'Completed' 
              BEGIN 
                  UPDATE [dbo].[trecruitcanbasicdtls] 
                  SET    [conflictallow] = 'Reschedule' 
                  WHERE  [candidateid] = @candidateid 
              END 
            ELSE 
              BEGIN 
                  SET @message=1 
              END 
        END 

      IF @action = 'SELECTEXAMNO' 
        BEGIN 
            SELECT [attemexam], 
                   CASE 
                     WHEN [attemexam] = 1 THEN Cast('1st Exam' AS VARCHAR) 
                     WHEN [attemexam] = 2 THEN Cast('2nd Exam'AS VARCHAR) 
                     WHEN [attemexam] = 3 THEN Cast('3rd Exam'AS VARCHAR) 
                     ELSE Cast([attemexam]AS VARCHAR) + '' + 'th Exam' 
                   END [attemexamtext] 
            FROM   [dbo].[trecruitconflictexamdtls] 
            WHERE  candidateid = @candidateid 
                   AND finalsubmit = 'Yes' 
            ORDER  BY [attemexam] 
        END 

      IF @action = 'Selecttypewisetotalno' 
        BEGIN 
            SELECT c.[conquestype], 
                   a.questionid, 
                   a.answer, 
                   totscore 
            FROM   [dbo].[trecruitconflictcandidatedtls] a, 
                   [dbo].[trecruitconflictqusdtls] b, 
                   [dbo].[trecruitconflictquestype] c, 
                   [dbo].[trecruitconflictansdtls]f, 
                   [dbo].[trecruitcanbasicdtls] d, 
                   [dbo].[languages]e, 
                   (SELECT c.[conquestype], 
                           Sum (a.answer)totscore 
                    FROM   [dbo].[trecruitconflictcandidatedtls] a, 
                           [dbo].[trecruitconflictqusdtls] b, 
                           [dbo].[trecruitconflictquestype] c, 
                           [dbo].[trecruitconflictansdtls]f, 
                           [dbo].[trecruitcanbasicdtls] d, 
                           [dbo].[languages]e 
                    WHERE  a.[languageid] = b.[languageid] 
                           AND a.[questionid] = b.[quesserialno] 
                           AND b.[conquestypeid] = c.[id] 
                           AND a.[candidateid] = d.[candidateid] 
                           AND a.[languageid] = e.[id] 
                           AND a.answer = f.number 
                           AND a.[languageid] = f.[languageid] 
                           AND a.candidateid = @candidateid 
                           AND [candidateattemexam] = @candidateattemexam 
                    GROUP  BY c.[conquestype]) z 
            WHERE  a.[languageid] = b.[languageid] 
                   AND a.[questionid] = b.[quesserialno] 
                   AND b.[conquestypeid] = c.[id] 
                   AND a.[candidateid] = d.[candidateid] 
                   AND a.[languageid] = e.[id] 
                   AND a.answer = f.id 
                   AND a.candidateid = @candidateid 
                   AND [candidateattemexam] = @candidateattemexam 
                   AND c.[conquestype] = z.[conquestype] 
            ORDER  BY [conquestype] 
        END      

      IF @action = 'Activeinactiveresbutton' 
        BEGIN 
            SELECT 
                   a.[conflictallow] 
             FROM   [dbo].[trecruitcanbasicdtls] a                 
            WHERE  
                    a.candidateid = @candidateid 
        END 
  END 
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: Languages, trecruitcanbasicdtls, trecruitcandidatesignup, trecruitconflictansdtls, trecruitconflictcandidatedtls, trecruitconflictcanlanguagemap, trecruitconflictexamdtls, trecruitconflictquestype, trecruitconflictqusdtls, trecruittraker */
/****** Object:  StoredProcedure [dbo].[procconflictmasdtls]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
CREATE PROC [dbo].[procconflictmasdtls] @action           NVARCHAR(100)=NULL,   
                                      @conquestype      NVARCHAR(100)=NULL,   
                                      @username         NVARCHAR(100)=NULL,   
                                      @activeflag       NVARCHAR(10)=NULL,   
                                      @conquestypeid    INT=NULL,   
                                      @languageid       INT=NULL,   
                                      @question         NVARCHAR(max)=NULL,   
                                      @questiondtlsid   INT=NULL,   
                                      @answer           NVARCHAR(max)=NULL,   
                                      @number           INT=NULL,   
                                      @answerdtlsid     INT=NULL,   
                                      @quesserialnonext INT=NULL,   
                                      @ollanguageid     INT=NULL,   
                                      @olquesserialno   INT=NULL,   
                                      @message          VARCHAR(500)=NULL output   
AS   
    DECLARE @empcode VARCHAR(100)   
    DECLARE @candidateid INT   
    DECLARE @anslanguageid INT   
    DECLARE @queslanguageid INT   
    DECLARE @countexamques INT   
    DECLARE @countexamattm INT   
    DECLARE @countexamattques INT   
    DECLARE @quesserialno INT   
    DECLARE @maplanid INT   
    DECLARE @countexamattmcan INT   
    DECLARE @findques INT   
    DECLARE @idd INT   
    DECLARE @attemptno INT   
    DECLARE @cattemptno INT   
    DECLARE @atteptestno INT   
  
  BEGIN   
  Begin Tran 
Begin Try 
      SELECT @empcode = empcode   
      FROM   essp.dbo.emp   
      WHERE  empemail = @username   
  
      SELECT @candidateid = candidateid   
      FROM   [dbo].[trecruitcandidatesignup]   
      WHERE  [username] = @username   
  
      SELECT @maplanid = languageid   
      FROM   [dbo].[trecruitconflictcanlanguagemap] p   
      WHERE  candidateid = @candidateid   
  
      SELECT @countexamques = Count([question])   
      FROM   [dbo].[trecruitconflictqusdtls]   
      WHERE  [languageid] = @maplanid   
  
      SELECT @quesserialno = Min(quesserialno)   
      FROM   [dbo].[trecruitconflictqusdtls] p   
      WHERE  languageid = @maplanid   
             AND activeflag = 'yes'   
  
      SELECT @findques = Count(questionid)   
      FROM   [dbo].[trecruitconflictcandidatedtls]   
      WHERE  candidateid = @candidateid   
             AND questionid = @questiondtlsid   
             AND [quesfinalsubmitques] IS NULL   
  
      IF @action = 'Conquestypeinsert'   
        IF EXISTS(SELECT [conquestype]   
                  FROM   [dbo].[trecruitconflictquestype]   
                  WHERE  [conquestype] = @conquestype)   
          BEGIN   
              SET @message='Question Type Already Exists'   
  
              RETURN;   
          END   
        ELSE   
          BEGIN   
              INSERT INTO [dbo].[trecruitconflictquestype]   
                          ([conquestype],   
                           [activeflag],   
                           [createdby],   
                           [createdon],   
                           [updateddby],   
                           [updateddon])   
              VALUES      ( @conquestype,   
                            'Yes',   
                            @empcode,   
                            Getdate(),   
                            @empcode,   
                            Getdate() )   
  
              SET @message='Question Type Successfully Inserted'   
          END   
  
      IF @action = 'Conquestypeupdate'   
        IF EXISTS(SELECT [conquestype]   
                  FROM   [dbo].[trecruitconflictquestype]   
                  WHERE  [conquestype] = @conquestype)   
          BEGIN   
              SET @message='Question Type Already Exists'   
  
              RETURN;   
          END   
        ELSE   
          BEGIN   
              UPDATE [dbo].[trecruitconflictquestype]   
              SET    [conquestype] = @conquestype,   
                     [activeflag] = @activeflag,   
                     [updateddby] = @empcode,   
                     [updateddon] = Getdate()   
              WHERE  id = @conquestypeid   
  
              SET @message='Question Type Successfully Updated'   
          END   
  
      IF @action = 'Conquestypeselect'   
        BEGIN   
            SELECT [id],   
                   [conquestype],   
                   [activeflag]   
            FROM   [dbo].[trecruitconflictquestype]   
        END   
  
      IF @action = 'Conquesinsert'   
        IF EXISTS(SELECT [question]   
                  FROM   [dbo].[trecruitconflictqusdtls]   
                  WHERE  [question] = @question)   
          BEGIN   
              SET @message='Question Details Already Exists'   
  
              RETURN;   
          END   
        ELSE   
          BEGIN   
              SELECT @queslanguageid = Count(languageid)   
              FROM   [dbo].[trecruitconflictqusdtls]   
              WHERE  languageid = @languageid   
  
              INSERT INTO [dbo].[trecruitconflictqusdtls]   
                          (languageid,   
                           [quesserialno],   
                           [question],   
                           [conquestypeid],   
                           [activeflag],   
                           [createdby],   
                           [createdon],   
                           [updateddby],   
                           [updateddon])   
              VALUES      ( @languageid,   
                            @queslanguageid + 1,   
                            @question,   
                            @conquestypeid,   
                            'Yes',   
                            @empcode,   
                            Getdate(),   
                            @empcode,   
                            Getdate() )   
  
              SET @message='Question Details Successfully Inserted'   
          END   
  
      IF @action = 'Conquesupdate'   
        IF EXISTS(SELECT [question]   
                  FROM   [dbo].[trecruitconflictqusdtls]   
                  WHERE  [question] = @question)   
          BEGIN   
              SET @message='Question Details Already Exists'   
  
              RETURN;   
          END   
        ELSE   
          BEGIN   
              UPDATE [dbo].[trecruitconflictqusdtls]   
              SET    languageid = @languageid,   
                     [question] = @question,   
                     [conquestypeid] = @conquestypeid,   
                     [activeflag] = @activeflag,   
                     [updateddby] = @empcode,   
                     [updateddon] = Getdate()   
              WHERE  [id] = @questiondtlsid   
  
              SET @message='Question Details Successfully updated'   
          END   
  
      IF @action = 'Conquesselect'   
        BEGIN   
            SELECT ques.[id],   
                   ques.[languageid],   
                   ques.[quesserialno],   
                   lan.language,   
                   ques.[question],   
                   ques.[conquestypeid],   
                   qty.[conquestype],   
                   ques.[activeflag],   
                   ques.[createdby],   
                   ques.[createdon],   
                   ques.[updateddby],   
                   ques.[updateddon]   
            FROM   [dbo].[trecruitconflictqusdtls] ques,   
                   [dbo].[languages] lan,   
                   [dbo].[trecruitconflictquestype] qty   
            WHERE  ques.[languageid] = lan.[id]   
                   AND lan.[id] = @languageid   
                   AND ques.[conquestypeid] = qty.id   
            ORDER  BY ques.[quesserialno]   
        END   
  
      IF @action = 'Conquesansinsert'   
        IF EXISTS(SELECT [answer]   
                  FROM   [dbo].[trecruitconflictansdtls]   
                  WHERE  [answer] = @answer)   
          BEGIN   
              SET @message='Answer Details Already Exists'   
  
              RETURN;   
          END   
        ELSE   
          BEGIN   
              SELECT @anslanguageid = Count(languageid)   
              FROM   [dbo].[trecruitconflictansdtls]   
              WHERE  languageid = @languageid   
  
              INSERT INTO [dbo].[trecruitconflictansdtls]   
                          (languageid,   
                           [number],   
                           [answer],   
                           [activeflag],   
                           [createdby],   
                           [createdon],   
                           [updateddby],   
                           [updateddon])   
              VALUES      ( @languageid,   
                            @anslanguageid + 1,   
                            @answer,   
                            'Yes',   
                            @empcode,   
                            Getdate(),   
                            @empcode,   
                            Getdate() )   
  
              SET @message='Answer Details Successfully Inserted'   
          END   
  
      IF @action = 'Conquesansupdate'   
        IF EXISTS(SELECT [answer]   
                  FROM   [dbo].[trecruitconflictansdtls]   
                  WHERE  [answer] = @answer)   
          BEGIN   
              SET @message='Answer Details Already Exists'   
  
              RETURN;   
          END   
        ELSE   
          BEGIN   
              UPDATE [dbo].[trecruitconflictansdtls]   
              SET    languageid = @languageid,   
                     --[number] = @number,                    
                     [answer] = @answer,   
                     [activeflag] = @activeflag,   
                     [createdby] = @empcode,   
                     [createdon] = Getdate(),   
                     [updateddby] = @empcode,   
                     [updateddon] = Getdate()   
              WHERE  id = @answerdtlsid   
  
              SET @message='Answer Details Successfully Updated'   
          END   
  
      IF @action = 'Concandidatelanguagemap'   
        BEGIN   
            DELETE FROM [dbo].[trecruitconflictcanlanguagemap]   
            WHERE  [candidateid] = @candidateid   
  
            INSERT INTO [dbo].[trecruitconflictcanlanguagemap]   
                        ([candidateid],   
                         [languageid])   
            VALUES      (@candidateid,   
                         @languageid)   
  
   SELECT @maplanid = languageid   
      FROM   [dbo].[trecruitconflictcanlanguagemap] p   
      WHERE  candidateid = @candidateid   
  
      SELECT @countexamques = Count([question])   
      FROM   [dbo].[trecruitconflictqusdtls]   
      WHERE  [languageid] = @maplanid   
  
            SELECT @attemptno = Count([attemexam])   
            FROM   [dbo].[trecruitconflictexamdtls]   
            WHERE  [finalsubmit] = 'Yes'   
                   AND candidateid = @candidateid   
  
            DELETE FROM [dbo].[trecruitconflictcandidatedtls]   
            WHERE  [quesfinalsubmitques] IS NULL   
                   AND candidateid = @candidateid   
  
            DELETE FROM [dbo].[trecruitconflictexamdtls]   
            WHERE  [finalsubmit] = 'No'   
                   AND candidateid = @candidateid   
  
            INSERT INTO [dbo].[trecruitconflictexamdtls]   
                        ([candidateid],   
                         [languageid],   
                         [totalques],   
                         [attemques],   
                         [finalsubmit],   
                         [attemexam])   
            VALUES      ( @candidateid,   
                          @languageid,   
                          @countexamques,   
                          null,   
                          'No',   
                          @attemptno + 1 )   
        END   
  
      IF @action = 'Conquesansselect'   
        BEGIN   
            SELECT previousvalue,   
                   previousvalueques,   
                   quesserialno,   
                   question,   
                   nextvalue,   
                   nextvalueques,   
                   noofques   
            FROM   (SELECT Lag(p.quesserialno)   
                             OVER (                                  ORDER BY p.[id]) PreviousValue,   
                           Lag(p.question)   
                             OVER (   
                               ORDER BY p.[id]) PreviousValueques,   
                           p.quesserialno,   
                           p.question,   
                           Lead(p.quesserialno)   
                             OVER (   
                               ORDER BY p.[id]) NextValue,   
                           Lead(p.question)   
                             OVER (   
                               ORDER BY p.[id]) NextValueques,   
                           languageid   
                    FROM   [dbo].[trecruitconflictqusdtls] p   
                    WHERE  languageid = @maplanid   
                           AND activeflag = 'yes')s,   
                   (SELECT languageid,   
                           Count([question])noofques   
                    FROM   [dbo].[trecruitconflictqusdtls]   
                    WHERE  languageid = @maplanid   
                           AND activeflag = 'Yes'   
                    GROUP  BY languageid) p   
            WHERE  quesserialno = @quesserialno   
                   AND p.languageid = s.languageid   
        END   
  
      IF @action = 'Conquesansselectnext'   
        BEGIN   
            SELECT previousvalue,   
                   previousvalueques,   
                   quesserialno,   
                   question,   
                   nextvalue,   
                   nextvalueques,   
                   noofques,   
                   CASE   
                     WHEN x.candidateid IS NULL THEN 0   
                     ELSE x.candidateid   
                   END candidateid,   
                   CASE   
                     WHEN x.[answer] IS NULL THEN 0   
                     ELSE x.[answer]   
                   END answer,   
                   CASE   
                     WHEN y.[attemques] BETWEEN 1 AND 100 THEN y.[attemques]   
                     ELSE y.[attemques]   
                   END [attemques]   
            FROM   (SELECT Lag(p.quesserialno)   
                             OVER (   
                               ORDER BY p.[id]) PreviousValue,   
                           Lag(p.question)   
                             OVER (   
                               ORDER BY p.[id]) PreviousValueques,   
                           p.quesserialno,   
                           p.question,   
                           Lead(p.quesserialno)   
                             OVER (   
                               ORDER BY p.[id]) NextValue,   
                           Lead(p.question)   
                             OVER (   
                               ORDER BY p.[id]) NextValueques,   
                           languageid   
                    FROM   [dbo].[trecruitconflictqusdtls] p   
                    WHERE  languageid = @maplanid   
                           AND activeflag = 'yes')s   
                   LEFT OUTER JOIN   
                   [dbo].[trecruitconflictcandidatedtls]   
                   x   
                                ON s.languageid = x.[languageid]   
                                   AND s.quesserialno = x.[questionid]   
                                   AND [quesfinalsubmitques] IS NULL   
                                   AND x.[candidateid] = @candidateid,   
                   (SELECT languageid,   
                           Count([question])noofques   
                    FROM   [dbo].[trecruitconflictqusdtls]   
                    WHERE  languageid = @maplanid   
                           AND activeflag = 'Yes'   
                    GROUP  BY languageid) p,   
                   [dbo].[trecruitconflictexamdtls] y   
            WHERE  quesserialno = @quesserialnonext   
                   AND p.languageid = s.languageid   
                   AND s.languageid = y.[languageid]   
                   AND y.[candidateid] = @candidateid   
                   AND [finalsubmit] <> 'Yes'   
        END   
  
      IF @action = 'Conansselect'   
        BEGIN   
            SELECT [number],   
                   [answer],   
                   language   
            FROM   [dbo].[trecruitconflictansdtls] ans,   
                   [dbo].[languages] lan   
            WHERE  ans.[languageid] = lan.[id]   
                   AND lan.[id] = @maplanid   
        END   
  
      IF @action = 'Conolquesansselect'   
        BEGIN   
            SELECT [question]   
            FROM   [dbo].[trecruitconflictqusdtls]   
            WHERE  languageid = @ollanguageid   
                   AND quesserialno = @olquesserialno   
  
            SELECT [number],   
                   [answer]   
            FROM   [dbo].[trecruitconflictansdtls] ans   
            WHERE  ans.[languageid] = @ollanguageid   
        END   
  
      IF @action = 'Conansselecthr'   
        BEGIN   
            SELECT [number],   
                   [answer],   
                   language   
            FROM   [dbo].[trecruitconflictansdtls] ans,   
                   [dbo].[languages] lan   
            WHERE  ans.[languageid] = lan.[id]   
                   AND lan.[id] = @languageid   
        END   
  
      IF @action = 'Concandtlsinsert'   
         AND @findques = 0   
        BEGIN   
            SELECT @countexamattm = [attemexam]   
            FROM   [dbo].[trecruitconflictexamdtls]   
            WHERE  [candidateid] = @candidateid   
                   AND finalsubmit <> 'Yes'   
  
            SELECT @countexamattmcan = Count([candidateid])   
            FROM   [dbo].[trecruitconflictexamdtls]   
            WHERE  [candidateid] = @candidateid   
  
            BEGIN   
                INSERT INTO [dbo].[trecruitconflictcandidatedtls]   
                            ([candidateid],   
                             [languageid],   
                             [questionid],   
                             [answer],   
                             candidateattemexam,   
                             [createdon],   
                             [updatedon])   
                VALUES      ( @candidateid,   
                              @maplanid,   
                              @questiondtlsid,   
                              @number,   
                              @countexamattm,   
                              Getdate(),   
                              Getdate() )   
  
                SET @message='Answer Details Successfully Inserted'   
            END   
  
            SELECT @countexamattques = Count([questionid])   
            FROM   [dbo].[trecruitconflictcandidatedtls]   
            WHERE  candidateid = @candidateid   
                   AND answer <> 0   
                   AND quesfinalsubmitques IS NULL   
  
            IF @countexamattm IS NOT NULL   
              BEGIN   
                  UPDATE [dbo].[trecruitconflictexamdtls]   
                  SET    [attemques] = [totalques] - @countexamattques   
                  WHERE  candidateid = @candidateid   
                         AND finalsubmit <> 'Yes'   
              END   
        END   
  
      IF @action = 'Concandtlsinsert'   
         AND @findques > 0   
        BEGIN   
            SELECT @countexamattm = [attemexam]   
            FROM   [dbo].[trecruitconflictexamdtls]   
            WHERE  [candidateid] = @candidateid   
                   AND finalsubmit <> 'Yes'   
  
            UPDATE [dbo].[trecruitconflictcandidatedtls]   
            SET    [answer] = @number,   
                   [updatedon] = Getdate()   
            WHERE  [candidateid] = @candidateid   
                   AND [questionid] = @questiondtlsid   
                   AND [quesfinalsubmitques] IS NULL   
  
            SET @message='Answer Details Successfully Updated'   
  
            SELECT @countexamattques = Count([questionid])   
            FROM   [dbo].[trecruitconflictcandidatedtls]   
            WHERE  candidateid = @candidateid   
                   AND answer <> 0   
                   AND quesfinalsubmitques IS NULL   
  
            IF @countexamattm IS NOT NULL   
              BEGIN   
         UPDATE [dbo].[trecruitconflictexamdtls]   
                  SET    [attemques] = [totalques] - @countexamattques   
                  WHERE  candidateid = @candidateid   
                         AND finalsubmit <> 'Yes'   
              END   
        END   
  
      IF @action = 'Finalsubmit'   
        BEGIN   
            UPDATE [dbo].[trecruitconflictexamdtls]   
            SET    [finalsubmit] = 'Yes'   
            WHERE  candidateid = @candidateid   
  
            --UPDATE [dbo].[trecruittraker]   
            --SET    [conflictallow] = 'Completed'   
            --WHERE  candidateid = @candidateid   
  
   -----------------------------------------  
   UPDATE [dbo].[trecruitcanbasicdtls]   
            SET    [conflictallow] = 'Completed'   
            WHERE  candidateid = @candidateid   
   -------------------------------------------  
  
            UPDATE [dbo].[trecruitconflictcandidatedtls]   
            SET    [quesfinalsubmitques] = 'F'   
            WHERE  candidateid = @candidateid   
        END   
  
      IF @action = 'Concandtlsselect'   
        BEGIN   
            SELECT disc.[id],   
                   disc.[candidateid],   
                   disc.[languageid],   
                   disc.[questionid],   
                   ques.[question],   
                   disc.[answer]   
            FROM   [dbo].[trecruitconflictcandidatedtls] disc,   
                   [dbo].[trecruitconflictqusdtls] ques   
            WHERE  [candidateid] = @candidateid   
                   AND [questionid] = @questiondtlsid   
                   AND disc.[questionid] = ques.id   
        END   
  
      IF @action = 'Concandtlsselect'   
        BEGIN   
            IF NOT EXISTS (SELECT candidateid   
                           FROM   
                   [dbo].[trecruitconflictcandidatedtls]   
                           WHERE  candidateid = @candidateid)   
              BEGIN   
                  SELECT Min([id]),   
                         [question]   
                  FROM   [dbo].[trecruitconflictqusdtls]   
                  WHERE  [languageid] = @languageid   
                         AND activeflag = 'Yes'   
                  GROUP  BY [languageid],   
                            [question]   
  
                  SELECT [number],   
                         [answer]   
                  FROM   [dbo].[trecruitconflictansdtls]   
                  WHERE  [languageid] = @languageid   
                         AND activeflag = 'Yes'   
              END   
        --SELECT disc.[id],                    
        --       disc.[candidateid],                    
        --       disc.[languageid],                    
        --       disc.[questionid],                    
        --       ques.[question],                    
        --       disc.[answer]                    
        --FROM   [dbo].[trecruitconflictcandidatedtls] disc,                    
        --       [dbo].[trecruitconflictqusdtls] ques                    
        --WHERE  [candidateid] = @candidateid                    
        --       AND [questionid] = @questiondtlsid                    
        --       AND disc.[questionid] = ques.id                    
        END   
  
      IF @action = 'Conansqnoselect'   
        BEGIN   
            SELECT @atteptestno = [attemexam]   
            FROM   [dbo].[trecruitconflictexamdtls]   
            WHERE  [finalsubmit] <> 'Yes'   
                   AND [candidateid] = @candidateid   
  
            SELECT [questionid]   
            FROM   [dbo].[trecruitconflictcandidatedtls]   
            WHERE  [answer] > 0   
                   AND [candidateattemexam] = @atteptestno   
                   AND [candidateid] = @candidateid   
        END   

		Commit Tran 
	Set @message=''
End Try 
Begin Catch 
	Rollback Tran 
	Set @message=dbo.fnErrors()
End Catch 
	Select @message
  END   
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: trecruitcanbasicdtls, trecruitotherpost */
/****** Object:  StoredProcedure [dbo].[procdiscandidatenamepost]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[procdiscandidatenamepost]
 
                                 @registrationnumber VARCHAR(200)=NULL
as
DECLARE @candidateid INT 
begin

SELECT @candidateid = candidateid 
      FROM   [dbo].[trecruitcanbasicdtls] 
      WHERE  registrationnumber = @registrationnumber 

SELECT a.[firstname] + ' ' + a.[middlename] + ' ' 
                   + a.[lastname] CandidateName, 
                   b.position postname 
                    
            FROM   [dbo].[trecruitcanbasicdtls] a, [dbo].[vw_canapppost] b                   
            WHERE  a.candidateid = b.candidateid 
                   AND a.candidateid = @candidateid
				   union
        SELECT a.[firstname] + ' ' + a.[middlename] + ' ' 
                   + a.[lastname] CandidateName, 
                   b.[otpostname] postname 
                    
            FROM   [dbo].[trecruitcanbasicdtls] a, [dbo].[trecruitotherpost] b                   
            WHERE  a.candidateid = b.candidateid 
                   AND a.candidateid = @candidateid
				   end
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: Languages, trecruitcanbasicdtls, trecruitdiscrolansdtls, trecruitdiscrolcandidatedtls, trecruitdiscrolquestype, trecruitdiscrolqusdtls */
/****** Object:  StoredProcedure [dbo].[procdisCHAMELEONtotalno]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                         
						 CREATE proc [dbo].[procdisCHAMELEONtotalno]
						 @candidateattemexam INT=NULL, 
@registrationnumber VARCHAR(200)=NULL 
						 as
						 DECLARE @candidateid INT 
						 begin

						 SELECT @candidateid = candidateid 
      FROM   [dbo].[trecruitcanbasicdtls] 
      WHERE  registrationnumber = @registrationnumber 

						 SELECT 
                           a.questionid, 
                           a.answer
                    FROM   [dbo].[trecruitdiscrolcandidatedtls] a, 
                           [dbo].[trecruitdiscrolqusdtls] b, 
                           [dbo].[trecruitdiscrolquestype] c, 
                           [dbo].[trecruitdiscrolansdtls]f, 
                           [dbo].[trecruitcanbasicdtls] d, 
                           [dbo].[languages]e 
                    WHERE  a.[languageid] = b.[languageid] 
                           AND a.[questionid] = b.[quesserialno] 
                           AND b.[disquestypeid] = c.[id] 
                           AND a.[candidateid] = d.[candidateid] 
                           AND a.[languageid] = e.[id] 
                           AND a.answer = f.[number]
						   and a.[languageid]=f.[languageid]                            
                           AND [candidateattemexam] = @candidateattemexam
                           AND c.[disquestype] = 'CHAMELEON' 
						   and a.candidateid=@candidateid

						   end
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: trecruitdiscrolexaminstraction */
/****** Object:  StoredProcedure [dbo].[procdiscrolexamguideline]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Script for SelectTopNRows command from SSMS  ******/

CREATE proc [dbo].[procdiscrolexamguideline]
as
begin
SELECT [fname]
      ,[ftype]
      ,[resumefile]
  FROM [dbo].[trecruitdiscrolexaminstraction]

  end
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: Languages, trecruitcanbasicdtls, trecruitcandidatesignup, trecruitdiscrolansdtls, trecruitdiscrolcandidatedtls, trecruitdiscrolecanlanguagemap, trecruitdiscrolexamdtls, trecruitdiscrolquestype, trecruitdiscrolqusdtls, trecruittraker */
/****** Object:  StoredProcedure [dbo].[procdiscrolmasdtls]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[procdiscrolmasdtls] @action           NVARCHAR(100)=NULL, 
                                      @disquestype      NVARCHAR(100)=NULL, 
                                      @username         NVARCHAR(100)=NULL, 
                                      @activeflag       NVARCHAR(10)=NULL, 
                                      @disquestypeid    INT=NULL, 
                                      @languageid       INT=NULL, 
                                      @question         NVARCHAR(max)=NULL, 
                                      @questiondtlsid   INT=NULL, 
                                      @answer           NVARCHAR(max)=NULL, 
                                      @number           INT=NULL, 
                                      @answerdtlsid     INT=NULL, 
                                      @quesserialnonext INT=NULL, 
                                      @ollanguageid     INT=NULL, 
                                      @olquesserialno   INT=NULL, 
                                      @message          VARCHAR(500)=NULL output 
AS 
    DECLARE @empcode VARCHAR(100) 
    DECLARE @candidateid INT 
    DECLARE @anslanguageid INT 
    DECLARE @queslanguageid INT 
    DECLARE @countexamques INT 
    DECLARE @countexamattm INT 
    DECLARE @countexamattques INT 
    DECLARE @quesserialno INT 
    DECLARE @maplanid INT 
    DECLARE @countexamattmcan INT 
    DECLARE @findques INT 
    DECLARE @idd INT 
    DECLARE @attemptno INT 
    DECLARE @cattemptno INT 
    DECLARE @atteptestno INT 

  BEGIN 
      SELECT @empcode = empcode 
      FROM   essp.dbo.emp 
      WHERE  empemail = @username 

      SELECT @candidateid = candidateid 
      FROM   [dbo].[trecruitcandidatesignup] 
      WHERE  [username] = @username 

      SELECT @maplanid = languageid 
      FROM   [dbo].[trecruitdiscrolecanlanguagemap] p 
      WHERE  candidateid = @candidateid 

      SELECT @countexamques = Count([question]) 
      FROM   [dbo].[trecruitdiscrolqusdtls] 
      WHERE  [languageid] = @maplanid 

      SELECT @quesserialno = Min(quesserialno) 
      FROM   [dbo].[trecruitdiscrolqusdtls] p 
      WHERE  languageid = @maplanid 
             AND activeflag = 'yes' 

      SELECT @findques = Count(questionid) 
      FROM   [dbo].[trecruitdiscrolcandidatedtls] 
      WHERE  candidateid = @candidateid 
             AND questionid = @questiondtlsid 
             AND [quesfinalsubmitques] IS NULL 

      IF @action = 'Disquestypeinsert' 
        IF EXISTS(SELECT [disquestype] 
                  FROM   [dbo].[trecruitdiscrolquestype] 
                  WHERE  [disquestype] = @disquestype) 
          BEGIN 
              SET @message='Question Type Already Exists' 

              RETURN; 
          END 
        ELSE 
          BEGIN 
              INSERT INTO [dbo].[trecruitdiscrolquestype] 
                          ([disquestype], 
                           [activeflag], 
                           [createdby], 
                           [createdon], 
                           [updateddby], 
                           [updateddon]) 
              VALUES      ( @disquestype, 
                            'Yes', 
                            @empcode, 
                            Getdate(), 
                            @empcode, 
                            Getdate() ) 

              SET @message='Question Type Successfully Inserted' 
          END 

      IF @action = 'Disquestypeupdate' 
        IF EXISTS(SELECT [disquestype] 
                  FROM   [dbo].[trecruitdiscrolquestype] 
                  WHERE  [disquestype] = @disquestype) 
          BEGIN 
              SET @message='Question Type Already Exists' 

              RETURN; 
          END 
        ELSE 
          BEGIN 
              UPDATE [dbo].[trecruitdiscrolquestype] 
              SET    [disquestype] = @disquestype, 
                     [activeflag] = @activeflag, 
                     [updateddby] = @empcode, 
                     [updateddon] = Getdate() 
              WHERE  id = @disquestypeid 

              SET @message='Question Type Successfully Updated' 
          END 

      IF @action = 'Disquestypeselect' 
        BEGIN 
            SELECT [id], 
                   [disquestype], 
                   [activeflag] 
            FROM   [dbo].[trecruitdiscrolquestype] 
        END 

      IF @action = 'Disquesinsert' 
        IF EXISTS(SELECT [question] 
                  FROM   [dbo].[trecruitdiscrolqusdtls] 
                  WHERE  [question] = @question) 
          BEGIN 
              SET @message='Question Details Already Exists' 

              RETURN; 
          END 
        ELSE 
          BEGIN 
              SELECT @queslanguageid = Count(languageid) 
              FROM   [dbo].[trecruitdiscrolqusdtls] 
              WHERE  languageid = @languageid 

              INSERT INTO [dbo].[trecruitdiscrolqusdtls] 
                          (languageid, 
                           [quesserialno], 
                           [question], 
                           [disquestypeid], 
                           [activeflag], 
                           [createdby], 
                           [createdon], 
                           [updateddby], 
                           [updateddon]) 
              VALUES      ( @languageid, 
                            @queslanguageid + 1, 
                            @question, 
                            @disquestypeid, 
                            'Yes', 
                            @empcode, 
                            Getdate(), 
                            @empcode, 
                            Getdate() ) 

              SET @message='Question Details Successfully Inserted' 
          END 

      IF @action = 'Disquesupdate' 
        IF EXISTS(SELECT [question] 
                  FROM   [dbo].[trecruitdiscrolqusdtls] 
                  WHERE  [question] = @question) 
          BEGIN 
              SET @message='Question Details Already Exists' 

              RETURN; 
          END 
        ELSE 
          BEGIN 
              UPDATE [dbo].[trecruitdiscrolqusdtls] 
              SET    languageid = @languageid, 
                     [question] = @question, 
                     [disquestypeid] = @disquestypeid, 
                     [activeflag] = @activeflag, 
                     [updateddby] = @empcode, 
                     [updateddon] = Getdate() 
              WHERE  [id] = @questiondtlsid 

              SET @message='Question Details Successfully updated' 
          END 

      IF @action = 'Disquesselect' 
        BEGIN 
            SELECT ques.[id], 
                   ques.[languageid], 
                   ques.[quesserialno], 
                   lan.language, 
                   ques.[question], 
                   ques.[disquestypeid], 
                   qty.[disquestype], 
                   ques.[activeflag], 
                   ques.[createdby], 
                   ques.[createdon], 
                   ques.[updateddby], 
                   ques.[updateddon] 
            FROM   [dbo].[trecruitdiscrolqusdtls] ques, 
                   [dbo].[languages] lan, 
                   [dbo].[trecruitdiscrolquestype] qty 
            WHERE  ques.[languageid] = lan.[id] 
                   AND lan.[id] = @languageid 
                   AND ques.[disquestypeid] = qty.id 
            ORDER  BY ques.[quesserialno] 
        END 

      IF @action = 'Disquesansinsert' 
        IF EXISTS(SELECT [answer] 
                  FROM   [dbo].[trecruitdiscrolansdtls] 
                  WHERE  [answer] = @answer) 
          BEGIN 
              SET @message='Answer Details Already Exists' 

              RETURN; 
          END 
        ELSE 
          BEGIN 
              SELECT @anslanguageid = Count(languageid) 
              FROM   [dbo].[trecruitdiscrolansdtls] 
              WHERE  languageid = @languageid 

              INSERT INTO [dbo].[trecruitdiscrolansdtls] 
                          (languageid, 
                           [number], 
                           [answer], 
                           [activeflag], 
                           [createdby], 
                           [createdon], 
                           [updateddby], 
                           [updateddon]) 
              VALUES      ( @languageid, 
                            @anslanguageid + 1, 
                            @answer, 
                            'Yes', 
                            @empcode, 
                            Getdate(), 
                            @empcode, 
                            Getdate() ) 

              SET @message='Answer Details Successfully Inserted' 
          END 

      IF @action = 'Disquesansupdate' 
        IF EXISTS(SELECT [answer] 
                  FROM   [dbo].[trecruitdiscrolansdtls] 
                  WHERE  [answer] = @answer) 
          BEGIN 
              SET @message='Answer Details Already Exists' 

              RETURN; 
          END 
        ELSE 
          BEGIN 
              UPDATE [dbo].[trecruitdiscrolansdtls] 
              SET    languageid = @languageid, 
                     --[number] = @number,                  
                     [answer] = @answer, 
                     [activeflag] = @activeflag, 
                     [createdby] = @empcode, 
                     [createdon] = Getdate(), 
                     [updateddby] = @empcode, 
                     [updateddon] = Getdate() 
              WHERE  id = @answerdtlsid 

              SET @message='Answer Details Successfully Updated' 
          END 

      IF @action = 'Discandidatelanguagemap' 
        BEGIN 
            DELETE FROM [dbo].[trecruitdiscrolecanlanguagemap] 
            WHERE  [candidateid] = @candidateid 

            INSERT INTO [dbo].[trecruitdiscrolecanlanguagemap] 
                        ([candidateid], 
                         [languageid]) 
            VALUES      (@candidateid, 
                         @languageid) 

	  SELECT @maplanid = languageid 
      FROM   [dbo].[trecruitdiscrolecanlanguagemap] p 
      WHERE  candidateid = @candidateid 

      SELECT @countexamques = Count([question]) 
      FROM   [dbo].[trecruitdiscrolqusdtls] 
      WHERE  [languageid] = @maplanid 

            SELECT @attemptno = Count([attemexam]) 
            FROM   [dbo].[trecruitdiscrolexamdtls] 
            WHERE  [finalsubmit] = 'Yes' 
                   AND candidateid = @candidateid 

            DELETE FROM [dbo].[trecruitdiscrolcandidatedtls] 
            WHERE  [quesfinalsubmitques] IS NULL 
                   AND candidateid = @candidateid 

            DELETE FROM [dbo].[trecruitdiscrolexamdtls] 
            WHERE  [finalsubmit] = 'No' 
                   AND candidateid = @candidateid 

            INSERT INTO [dbo].[trecruitdiscrolexamdtls] 
                        ([candidateid], 
                         [languageid], 
                         [totalques], 
                         [attemques], 
                         [finalsubmit], 
                         [attemexam]) 
            VALUES      ( @candidateid, 
                          @languageid, 
                          @countexamques, 
                          null, 
                          'No', 
                          @attemptno + 1 ) 
        END 

      IF @action = 'Disquesansselect' 
        BEGIN 
            SELECT previousvalue, 
                   previousvalueques, 
                   quesserialno, 
                   question, 
                   nextvalue, 
                   nextvalueques, 
                   noofques 
            FROM   (SELECT Lag(p.quesserialno) 
                             OVER ( 
                               ORDER BY p.[id]) PreviousValue, 
                           Lag(p.question) 
                             OVER ( 
                               ORDER BY p.[id]) PreviousValueques, 
                           p.quesserialno, 
                           p.question, 
                           Lead(p.quesserialno) 
                             OVER ( 
                               ORDER BY p.[id]) NextValue, 
                           Lead(p.question) 
                             OVER ( 
                               ORDER BY p.[id]) NextValueques, 
                           languageid 
                    FROM   [dbo].[trecruitdiscrolqusdtls] p 
                    WHERE  languageid = @maplanid 
                           AND activeflag = 'yes')s, 
                   (SELECT languageid, 
                           Count([question])noofques 
                    FROM   [dbo].[trecruitdiscrolqusdtls] 
                    WHERE  languageid = @maplanid 
                           AND activeflag = 'Yes' 
                    GROUP  BY languageid) p 
            WHERE  quesserialno = @quesserialno 
                   AND p.languageid = s.languageid 
        END 

      IF @action = 'Disquesansselectnext' 
        BEGIN 
            SELECT previousvalue, 
                   previousvalueques, 
                   quesserialno, 
                   question, 
                   nextvalue, 
                   nextvalueques, 
                   noofques, 
                   CASE 
                     WHEN x.candidateid IS NULL THEN 0 
                     ELSE x.candidateid 
                   END candidateid, 
                   CASE 
                     WHEN x.[answer] IS NULL THEN 0 
                     ELSE x.[answer] 
                   END answer, 
                   ISNULL(CASE 
                     WHEN y.[attemques] BETWEEN 1 AND 100 THEN y.[attemques] 
                     ELSE y.[attemques] 
                   END,0) [attemques] 
            FROM   (SELECT Lag(p.quesserialno) 
                           --Change by Saikat sarkar on 15-11-24 for wrong question is coming for hindi
						   --  OVER ( 
                           --    ORDER BY p.[id]) PreviousValue, 
                           --Lag(p.question) 
                           --  OVER ( 
                           --    ORDER BY p.[id]) PreviousValueques, 
                           --p.quesserialno, 
                           --p.question, 
                           --Lead(p.quesserialno) 
                           --  OVER ( 
                           --    ORDER BY p.[id]) NextValue, 
                           --Lead(p.question) 
                           --  OVER ( 
                           --    ORDER BY p.[id]) NextValueques, 

						   OVER ( 
                               ORDER BY p.[quesserialno]) PreviousValue, 
                           Lag(p.question) 
                             OVER ( 
                               ORDER BY p.[quesserialno]) PreviousValueques, 
                           p.quesserialno, 
                           p.question, 
                           Lead(p.quesserialno) 
                             OVER ( 
                               ORDER BY p.[quesserialno]) NextValue, 
                           Lead(p.question) 
                             OVER ( 
                               ORDER BY p.[quesserialno]) NextValueques,

                           languageid 
                    FROM   [dbo].[trecruitdiscrolqusdtls] p 
                    WHERE  languageid = @maplanid 
                           AND activeflag = 'yes')s 
                   LEFT OUTER JOIN 
                   [dbo].[trecruitdiscrolcandidatedtls] 
                   x 
                                ON s.languageid = x.[languageid] 
                                   AND s.quesserialno = x.[questionid] 
                                   AND [quesfinalsubmitques] IS NULL 
                                   AND x.[candidateid] = @candidateid, 
                   (SELECT languageid, 
                           Count([question])noofques 
                    FROM   [dbo].[trecruitdiscrolqusdtls] 
                    WHERE  languageid = @maplanid 
                           AND activeflag = 'Yes' 
                    GROUP  BY languageid) p, 
                   [dbo].[trecruitdiscrolexamdtls] y 
            WHERE  quesserialno = @quesserialnonext 
                   AND p.languageid = s.languageid 
                   AND s.languageid = y.[languageid] 
                   AND y.[candidateid] = @candidateid 
                   AND [finalsubmit] <> 'Yes' 
        END 

      IF @action = 'Disansselect' 
        BEGIN 
            SELECT [number], 
                   [answer], 
                   language 
            FROM   [dbo].[trecruitdiscrolansdtls] ans, 
                   [dbo].[languages] lan 
            WHERE  ans.[languageid] = lan.[id] 
                   AND lan.[id] = @maplanid 
        END 

      IF @action = 'Disolquesansselect' 
        BEGIN 
            SELECT [question] 
            FROM   [dbo].[trecruitdiscrolqusdtls] 
            WHERE  languageid = @ollanguageid 
                   AND quesserialno = @olquesserialno 

            SELECT [number], 
                   [answer] 
            FROM   [dbo].[trecruitdiscrolansdtls] ans 
            WHERE  ans.[languageid] = @ollanguageid 
        END 

      IF @action = 'Disansselecthr' 
        BEGIN 
            SELECT [number], 
                   [answer], 
                   language 
            FROM   [dbo].[trecruitdiscrolansdtls] ans, 
                   [dbo].[languages] lan 
            WHERE  ans.[languageid] = lan.[id] 
                   AND lan.[id] = @languageid 
        END 

      IF @action = 'Discandtlsinsert' 
         AND @findques = 0 
        BEGIN 
            SELECT @countexamattm = [attemexam] 
            FROM   [dbo].[trecruitdiscrolexamdtls] 
            WHERE  [candidateid] = @candidateid 
                   AND finalsubmit <> 'Yes' 

            SELECT @countexamattmcan = Count([candidateid]) 
            FROM   [dbo].[trecruitdiscrolexamdtls] 
            WHERE  [candidateid] = @candidateid 

            BEGIN 
                INSERT INTO [dbo].[trecruitdiscrolcandidatedtls] 
                            ([candidateid], 
                             [languageid], 
                             [questionid], 
                             [answer], 
                             candidateattemexam, 
                             [createdon], 
                             [updatedon]) 
                VALUES      ( @candidateid, 
                              @maplanid, 
                              @questiondtlsid, 
                              @number, 
                              @countexamattm, 
                              Getdate(), 
                              Getdate() ) 

                SET @message='Answer Details Successfully Inserted' 
            END 

            SELECT @countexamattques = Count([questionid]) 
            FROM   [dbo].[trecruitdiscrolcandidatedtls] 
            WHERE  candidateid = @candidateid 
                   AND answer <> 0 
                   AND quesfinalsubmitques IS NULL 

            IF @countexamattm IS NOT NULL 
              BEGIN 
                  UPDATE [dbo].[trecruitdiscrolexamdtls] 
                  SET    [attemques] = [totalques] - @countexamattques 
                  WHERE  candidateid = @candidateid 
                         AND finalsubmit <> 'Yes' 
              END 
        END 

      IF @action = 'Discandtlsinsert' 
         AND @findques > 0 
        BEGIN 
            SELECT @countexamattm = [attemexam] 
            FROM   [dbo].[trecruitdiscrolexamdtls] 
            WHERE  [candidateid] = @candidateid 
                   AND finalsubmit <> 'Yes' 

            UPDATE [dbo].[trecruitdiscrolcandidatedtls] 
            SET    [answer] = @number, 
                   [updatedon] = Getdate() 
            WHERE  [candidateid] = @candidateid 
                   AND [questionid] = @questiondtlsid 
                   AND [quesfinalsubmitques] IS NULL 

            SET @message='Answer Details Successfully Updated' 

            SELECT @countexamattques = Count([questionid]) 
            FROM   [dbo].[trecruitdiscrolcandidatedtls] 
            WHERE  candidateid = @candidateid 
                   AND answer <> 0 
                   AND quesfinalsubmitques IS NULL 

            IF @countexamattm IS NOT NULL 
              BEGIN 
                  UPDATE [dbo].[trecruitdiscrolexamdtls] 
                  SET    [attemques] = [totalques] - @countexamattques 
                  WHERE  candidateid = @candidateid 
                         AND finalsubmit <> 'Yes' 
              END 
        END 

      IF @action = 'Finalsubmit' 
        BEGIN 
            UPDATE [dbo].[trecruitdiscrolexamdtls] 
            SET    [finalsubmit] = 'Yes' 
            WHERE  candidateid = @candidateid 

            --UPDATE [dbo].[trecruittraker] 
            --SET    [discrolallow] = 'Completed' 
            --WHERE  candidateid = @candidateid 
			-----------------------------------------
			UPDATE [dbo].[trecruitcanbasicdtls] 
            SET    [discrolallow] = 'Completed' 
            WHERE  candidateid = @candidateid 
			-------------------------------------------
            UPDATE [dbo].[trecruitdiscrolcandidatedtls] 
            SET    [quesfinalsubmitques] = 'F' 
            WHERE  candidateid = @candidateid 
        END 

      IF @action = 'Discandtlsselect' 
        BEGIN 
            SELECT disc.[id], 
                   disc.[candidateid], 
                   disc.[languageid], 
                   disc.[questionid], 
                   ques.[question], 
                   disc.[answer] 
            FROM   [dbo].[trecruitdiscrolcandidatedtls] disc, 
                   [dbo].[trecruitdiscrolqusdtls] ques 
            WHERE  [candidateid] = @candidateid 
                   AND [questionid] = @questiondtlsid 
                   AND disc.[questionid] = ques.id 
        END 

      IF @action = 'Discandtlsselect' 
        BEGIN 
            IF NOT EXISTS (SELECT candidateid 
                           FROM 
                   [dbo].[trecruitdiscrolcandidatedtls] 
                           WHERE  candidateid = @candidateid) 
              BEGIN 
                  SELECT Min([id]), 
                         [question] 
                  FROM   [dbo].[trecruitdiscrolqusdtls] 
                  WHERE  [languageid] = @languageid 
                         AND activeflag = 'Yes' 
                  GROUP  BY [languageid], 
                            [question] 

                  SELECT [number], 
                         [answer] 
                  FROM   [dbo].[trecruitdiscrolansdtls] 
                  WHERE  [languageid] = @languageid 
                         AND activeflag = 'Yes' 
              END 
        --SELECT disc.[id],                  
        --       disc.[candidateid],                  
        --       disc.[languageid],                  
        --       disc.[questionid],                  
        --       ques.[question],                  
        --       disc.[answer]                  
        --FROM   [dbo].[trecruitdiscrolcandidatedtls] disc,                  
        --       [dbo].[trecruitdiscrolqusdtls] ques                  
        --WHERE  [candidateid] = @candidateid                  
        --       AND [questionid] = @questiondtlsid                  
        --       AND disc.[questionid] = ques.id                  
        END 

      IF @action = 'Disansqnoselect' 
        BEGIN 
            SELECT @atteptestno = [attemexam] 
            FROM   [dbo].[trecruitdiscrolexamdtls] 
            WHERE  [finalsubmit] <> 'Yes' 
                   AND [candidateid] = @candidateid 

            SELECT [questionid] 
            FROM   [dbo].[trecruitdiscrolcandidatedtls] 
            WHERE  [answer] > 0 
                   AND [candidateattemexam] = @atteptestno 
                   AND [candidateid] = @candidateid 
        END 
  END 
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: Languages, trecruitcanbasicdtls, trecruitdiscrolansdtls, trecruitdiscrolcandidatedtls, trecruitdiscrolquestype, trecruitdiscrolqusdtls */
/****** Object:  StoredProcedure [dbo].[procdisEAGLEtotalno]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                         
						 CREATE proc [dbo].[procdisEAGLEtotalno]
						 @candidateattemexam INT=NULL, 
                          @registrationnumber VARCHAR(200)=NULL 
						 as
						 DECLARE @candidateid INT 
						 begin

						 SELECT @candidateid = candidateid 
      FROM   [dbo].[trecruitcanbasicdtls] 
      WHERE  registrationnumber = @registrationnumber 

						 SELECT 
                           a.questionid, 
                           a.answer
                    FROM   [dbo].[trecruitdiscrolcandidatedtls] a, 
                           [dbo].[trecruitdiscrolqusdtls] b, 
                           [dbo].[trecruitdiscrolquestype] c, 
                           [dbo].[trecruitdiscrolansdtls]f, 
                           [dbo].[trecruitcanbasicdtls] d, 
                           [dbo].[languages]e 
                    WHERE  a.[languageid] = b.[languageid] 
                           AND a.[questionid] = b.[quesserialno] 
                           AND b.[disquestypeid] = c.[id] 
                           AND a.[candidateid] = d.[candidateid] 
                           AND a.[languageid] = e.[id] 
                           AND a.answer = f.[number]
						   and a.[languageid]=f.[languageid]                            
                           AND [candidateattemexam] = @candidateattemexam
                           AND c.[disquestype] = 'EAGLE' 
						  and a.candidateid=@candidateid

						   end
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: Languages, trecruitcanbasicdtls, trecruitcandidatesignup, trecruitdiscrolansdtls, trecruitdiscrolcandidatedtls, trecruitdiscrolexamdtls, trecruitdiscrolquestype, trecruitdiscrolqusdtls, trecruitotherpost, trecruitpostlocationmap, trecruittraker, trecuitpsycycotesttype */
/****** Object:  StoredProcedure [dbo].[procdishrdtls]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
         
/****** Script for SelectTopNRows command from SSMS  ******/           
CREATE PROC [dbo].[procdishrdtls] @action             VARCHAR(100)=NULL,           
                                 @phytypeid          INT=NULL,           
                                 @postname           VARCHAR(500)=NULL,           
                                 @deptname           VARCHAR(500)=NULL,           
                                 @candidateattemexam INT=NULL,           
                                 @registrationnumber VARCHAR(200)=NULL,           
                                 @discrolallow       VARCHAR(200)=NULL,           
                                 @Message            VARCHAR(200)=NULL           
AS           
    DECLARE @candidateid INT           
    DECLARE @candiscrolallow VARCHAR(200)           
          
  BEGIN         
  if(@phytypeid is null or @phytypeid=0)        
  begin        
  set        
  @phytypeid=null        
  end        
  if(@postname is null or @postname='0')        
  begin        
  set        
  @postname=null        
  end        
  if(@registrationnumber is null or @registrationnumber='0')        
  begin        
  set        
  @registrationnumber=null        
  end        
      SELECT @candidateid = candidateid           
      FROM   [dbo].[trecruitcanbasicdtls]           
      WHERE  registrationnumber = @registrationnumber           
          
            
          
          
      IF @action = 'Selecttypewisecandidate'           
        BEGIN           
                    
          
        SELECT Distinct [referenceno],           
                           [candidatename],           
                           [typename]           
            FROM   (SELECT [registrationnumber] [referenceno],           
                     b.[postname],          
          b.[deptname] departmentdivision,   d.Confidentialpost, d.Confidentialpostlink,      
                          dbo.Candidate_FullName(a.[firstname],a.[middlename],a.[lastname]) [candidatename],           
                           CASE           
                             WHEN discrolallow = 'Completed' THEN 1           
                             WHEN discrolallow = 'Reschedule' THEN 1           
        WHEN discrolallow = 'Yes' THEN 10          
                             ELSE discrolallow           
                           END discrolallow,           
                           CASE           
                             WHEN conflictallow = 'Completed' THEN 2           
                             WHEN conflictallow = 'Reschedule' THEN 2           
        WHEN conflictallow = 'Yes' THEN 10          
                             ELSE conflictallow           
                           END conflictallow,           
                           CASE           
                             WHEN iqallow = 'Completed' THEN 3           
                             WHEN iqallow = 'Reschedule' THEN 3           
        WHEN iqallow = 'Yes' THEN 10          
                             ELSE iqallow           
                           END iqallow,           
                           CASE           
                             WHEN eqallow = 'Completed' THEN 4           
                             WHEN eqallow = 'Reschedule' THEN 4           
        WHEN eqallow = 'Yes' THEN 10          
                             ELSE eqallow           
                           END eqallow ,          
         CASE           
                             WHEN bigfiveallow = 'Completed' THEN 5           
                             WHEN bigfiveallow = 'Reschedule' THEN 5           
        WHEN bigfiveallow = 'Yes' THEN 10          
                             ELSE bigfiveallow          
        end bigfiveallow,          
        CASE           
                             WHEN firoballow = 'Completed' THEN 6           
                             WHEN firoballow = 'Reschedule' THEN 6           
        WHEN firoballow = 'Yes' THEN 10          
                             ELSE firoballow           
                           END firoballow,           
        CASE           
                             WHEN myersbriggsallow = 'Completed' THEN 7           
                             WHEN myersbriggsallow = 'Reschedule' THEN 7           
        WHEN myersbriggsallow = 'Yes' THEN 10          
                             ELSE myersbriggsallow           
                           END myersbriggsallow           
                    FROM   [trecruitcanbasicdtls] a,[vw_apppost] b,[dbo].[trecruitcandidatesignup] c          
                           ,[dbo].[trecruitpostlocationmap] d  
                    WHERE            
       discrolallow IN ( 'Completed', 'Reschedule' )           
                                      
       and a.candidateid=c.candidateid          
       and c.username=b.username  
     and b.postid=d.postid and b.locid=d.locid) a,           
                   [dbo].[trecuitpsycycotesttype] b           
            WHERE  a.discrolallow = Cast(b.[id] AS VARCHAR)           
                   AND  (@phytypeid is null or b.id = @phytypeid)        
   and ((replace(replace(REPLACE(@postname, ' ', ''),'	',''),'		','') ) 
 is null or  (replace(replace(REPLACE(a.postname, ' ', ''),'	',''),'		','') =
	 replace(replace(REPLACE(@postname, ' ', ''),'	',''),'		','') ))        
                   AND (@deptname is null or a.departmentdivision = @deptname)      
        and  a.Confidentialpost='0'    
             
               
              
       union          
        SELECT Distinct [referenceno],           
                   [candidatename],           
                   [typename]           
            FROM   (SELECT [registrationnumber] [referenceno],           
                     b.[postname],          
          b.[deptname] departmentdivision, d.Confidentialpost, d.Confidentialpostlink,                       
                           dbo.Candidate_FullName(a.[firstname],a.[middlename],a.[lastname]) [candidatename],           
                           CASE           
                             WHEN discrolallow = 'Completed' THEN 1           
                             WHEN discrolallow = 'Reschedule' THEN 1           
        WHEN discrolallow = 'Yes' THEN 10          
                             ELSE discrolallow           
                           END discrolallow,           
                           CASE           
                             WHEN conflictallow = 'Completed' THEN 2           
                             WHEN conflictallow = 'Reschedule' THEN 2           
        WHEN conflictallow = 'Yes' THEN 10          
                             ELSE conflictallow           
                           END conflictallow,           
                           CASE           
                             WHEN iqallow = 'Completed' THEN 3           
                             WHEN iqallow = 'Reschedule' THEN 3           
        WHEN iqallow = 'Yes' THEN 10          
                             ELSE iqallow           
                           END iqallow,           
                           CASE           
                             WHEN eqallow = 'Completed' THEN 4           
                             WHEN eqallow = 'Reschedule' THEN 4           
        WHEN eqallow = 'Yes' THEN 10          
                             ELSE eqallow           
                           END eqallow ,          
          CASE           
                             WHEN bigfiveallow = 'Completed' THEN 5           
                             WHEN bigfiveallow = 'Reschedule' THEN 5           
        WHEN bigfiveallow = 'Yes' THEN 10          
                             ELSE bigfiveallow           
                           END bigfiveallow,          
         CASE           
                             WHEN firoballow = 'Completed' THEN 6           
                             WHEN firoballow = 'Reschedule' THEN 6           
        WHEN firoballow = 'Yes' THEN 10          
                             ELSE firoballow           
                           END firoballow,          
         CASE           
                             WHEN myersbriggsallow = 'Completed' THEN 7           
                             WHEN myersbriggsallow = 'Reschedule' THEN 7           
        WHEN myersbriggsallow = 'Yes' THEN 10          
                             ELSE myersbriggsallow           
                           END myersbriggsallow             
                    FROM   [trecruitcanbasicdtls] a,[vw_apppost] b,[dbo].[trecruitcandidatesignup] c  
            ,[dbo].[trecruitpostlocationmap] d  
          
                    WHERE            
                                     
                             conflictallow IN ( 'Completed', 'Reschedule' )      
                                      
       and a.candidateid=c.candidateid          
       and c.username=b.username  
    and b.postid=d.postid and b.locid=d.locid) a,           
                   [dbo].[trecuitpsycycotesttype] b           
            WHERE  a.conflictallow= Cast(b.[id] AS VARCHAR)           
                    AND  (@phytypeid is null or b.id = @phytypeid)   
					and ((replace(replace(REPLACE(@postname, ' ', ''),'	',''),'		','') ) 
 is null or  (replace(replace(REPLACE(a.postname, ' ', ''),'	',''),'		','') =
	 replace(replace(REPLACE(@postname, ' ', ''),'	',''),'		','') )) 
      -- and (@postname is null or a.postname = @postname )          
                   AND (@deptname is null or a.departmentdivision = @deptname)      
       and  a.Confidentialpost='0'  
       union          
        SELECT distinct [referenceno],           
                   [candidatename],           
                   [typename]           
            FROM   (SELECT [registrationnumber] [referenceno],           
                   b.[postname],          
          b.[deptname] departmentdivision,  d.Confidentialpost, d.Confidentialpostlink,             
                           dbo.Candidate_FullName(a.[firstname],a.[middlename],a.[lastname]) [candidatename],          
                           CASE           
                             WHEN discrolallow = 'Completed' THEN 1           
                             WHEN discrolallow = 'Reschedule' THEN 1           
        WHEN discrolallow = 'Yes' THEN 10          
                             ELSE discrolallow           
                           END discrolallow,           
                           CASE           
                             WHEN conflictallow = 'Completed' THEN 2           
                             WHEN conflictallow = 'Reschedule' THEN 2           
        WHEN conflictallow = 'Yes' THEN 10          
                             ELSE conflictallow           
           END conflictallow,           
                           CASE           
                             WHEN iqallow = 'Completed' THEN 3           
                             WHEN iqallow = 'Reschedule' THEN 3           
        WHEN iqallow = 'Yes' THEN 10          
                             ELSE iqallow           
                           END iqallow,           
                           CASE           
                             WHEN eqallow = 'Completed' THEN 4           
                             WHEN eqallow = 'Reschedule' THEN 4           
        WHEN eqallow = 'Yes' THEN 10          
                             ELSE eqallow           
                           END eqallow ,          
          CASE           
                             WHEN bigfiveallow = 'Completed' THEN 5           
                             WHEN bigfiveallow = 'Reschedule' THEN 5           
        WHEN bigfiveallow = 'Yes' THEN 10          
                             ELSE bigfiveallow           
                           END bigfiveallow,          
         CASE           
                             WHEN firoballow = 'Completed' THEN 6           
                             WHEN firoballow = 'Reschedule' THEN 6           
        WHEN firoballow = 'Yes' THEN 10          
                             ELSE firoballow           
                           END firoballow,          
         CASE           
                             WHEN myersbriggsallow = 'Completed' THEN 7           
                             WHEN myersbriggsallow = 'Reschedule' THEN 7           
        WHEN myersbriggsallow = 'Yes' THEN 10          
                             ELSE myersbriggsallow           
                           END myersbriggsallow             
                    FROM   [trecruitcanbasicdtls] a,[vw_apppost] b,[dbo].[trecruitcandidatesignup] c          
                            ,[dbo].[trecruitpostlocationmap] d    
                    WHERE            
                                     
                             eqallow IN ( 'Completed', 'Reschedule' )           
                                      
       and a.candidateid=c.candidateid          
       and c.username=b.username  
    and b.postid=d.postid and b.locid=d.locid) a,           
                   [dbo].[trecuitpsycycotesttype] b           
            WHERE  a.eqallow= Cast(b.[id] AS VARCHAR)           
                   AND  (@phytypeid is null or b.id = @phytypeid) 
				   and ((replace(replace(REPLACE(@postname, ' ', ''),'	',''),'		','') ) 
 is null or  (replace(replace(REPLACE(a.postname, ' ', ''),'	',''),'		','') =
	 replace(replace(REPLACE(@postname, ' ', ''),'	',''),'		','') )) 
      -- and (@postname is null or a.postname = @postname )          
                   AND (@deptname is null or a.departmentdivision = @deptname)    
         and  a.Confidentialpost='0'  
          
   union          
        SELECT Distinct [referenceno],           
                   [candidatename],           
                   [typename]           
            FROM   (SELECT [registrationnumber] [referenceno],           
                     b.[postname],          
          b.[deptname] departmentdivision,   d.Confidentialpost, d.Confidentialpostlink,                 
                           dbo.Candidate_FullName(a.[firstname],a.[middlename],a.[lastname]) [candidatename],           
                           CASE           
                             WHEN discrolallow = 'Completed' THEN 1           
                        WHEN discrolallow = 'Reschedule' THEN 1           
        WHEN discrolallow = 'Yes' THEN 10          
                             ELSE discrolallow           
                           END discrolallow,           
                           CASE           
                             WHEN conflictallow = 'Completed' THEN 2           
                             WHEN conflictallow = 'Reschedule' THEN 2           
        WHEN conflictallow = 'Yes' THEN 10          
          ELSE conflictallow           
                           END conflictallow,           
                           CASE           
                             WHEN iqallow = 'Completed' THEN 3           
                             WHEN iqallow = 'Reschedule' THEN 3           
        WHEN iqallow = 'Yes' THEN 10          
                             ELSE iqallow           
                           END iqallow,           
                           CASE           
                             WHEN eqallow = 'Completed' THEN 4           
                             WHEN eqallow = 'Reschedule' THEN 4           
        WHEN eqallow = 'Yes' THEN 10          
                             ELSE eqallow           
                           END eqallow ,          
          CASE           
                             WHEN bigfiveallow = 'Completed' THEN 5           
                             WHEN bigfiveallow = 'Reschedule' THEN 5           
        WHEN bigfiveallow = 'Yes' THEN 10          
                             ELSE bigfiveallow           
                           END bigfiveallow,          
         CASE           
        WHEN firoballow = 'Completed' THEN 6           
                             WHEN firoballow = 'Reschedule' THEN 6           
        WHEN firoballow = 'Yes' THEN 10          
                             ELSE firoballow           
                           END firoballow,          
         CASE           
                             WHEN myersbriggsallow = 'Completed' THEN 7           
                             WHEN myersbriggsallow = 'Reschedule' THEN 7           
        WHEN myersbriggsallow = 'Yes' THEN 10          
                             ELSE myersbriggsallow           
                           END myersbriggsallow             
                    FROM   [trecruitcanbasicdtls] a,[vw_apppost] b,[dbo].[trecruitcandidatesignup] c          
                       ,[dbo].[trecruitpostlocationmap] d    
                    WHERE            
                                     
                             iqallow IN ( 'Completed', 'Reschedule' )           
                                      
       and a.candidateid=c.candidateid          
       and c.username=b.username  
    and b.postid=d.postid and b.locid=d.locid) a,           
                   [dbo].[trecuitpsycycotesttype] b           
            WHERE  a.iqallow= Cast(b.[id] AS VARCHAR)           
                    AND  (@phytypeid is null or b.id = @phytypeid)    
					and ((replace(replace(REPLACE(@postname, ' ', ''),'	',''),'		','') ) 
 is null or  (replace(replace(REPLACE(a.postname, ' ', ''),'	',''),'		','') =
	 replace(replace(REPLACE(@postname, ' ', ''),'	',''),'		','') )) 
      -- and (@postname is null or a.postname = @postname )          
                   AND (@deptname is null or a.departmentdivision = @deptname)   
        and a.Confidentialpost='0'  
   union          
        SELECT Distinct [referenceno],           
                   [candidatename],           
                   [typename]           
            FROM   (SELECT [registrationnumber] [referenceno],           
                     b.[postname],          
          b.[deptname] departmentdivision,  d.Confidentialpost, d.Confidentialpostlink,                  
                           dbo.Candidate_FullName(a.[firstname],a.[middlename],a.[lastname]) [candidatename],          
                           CASE           
                             WHEN discrolallow = 'Completed' THEN 1           
                             WHEN discrolallow = 'Reschedule' THEN 1           
        WHEN discrolallow = 'Yes' THEN 10          
                             ELSE discrolallow           
                           END discrolallow,           
                           CASE           
                             WHEN conflictallow = 'Completed' THEN 2           
                             WHEN conflictallow = 'Reschedule' THEN 2           
        WHEN conflictallow = 'Yes' THEN 10          
                             ELSE conflictallow           
                           END conflictallow,           
                           CASE           
                             WHEN iqallow = 'Completed' THEN 3           
                             WHEN iqallow = 'Reschedule' THEN 3           
        WHEN iqallow = 'Yes' THEN 10          
                             ELSE iqallow           
                           END iqallow,           
                           CASE           
                             WHEN eqallow = 'Completed' THEN 4           
                             WHEN eqallow = 'Reschedule' THEN 4           
        WHEN eqallow = 'Yes' THEN 10          
                             ELSE eqallow           
                           END eqallow ,          
          CASE           
                             WHEN bigfiveallow = 'Completed' THEN 5           
                             WHEN bigfiveallow = 'Reschedule' THEN 5           
        WHEN bigfiveallow = 'Yes' THEN 10          
                             ELSE bigfiveallow           
                           END bigfiveallow ,          
         CASE           
                             WHEN firoballow = 'Completed' THEN 6           
                             WHEN firoballow = 'Reschedule' THEN 6           
        WHEN firoballow = 'Yes' THEN 10          
                             ELSE firoballow           
                           END firoballow,          
         CASE           
                             WHEN myersbriggsallow = 'Completed' THEN 7           
                             WHEN myersbriggsallow = 'Reschedule' THEN 7           
        WHEN myersbriggsallow = 'Yes' THEN 10          
                             ELSE myersbriggsallow           
                           END myersbriggsallow            
                    FROM   [trecruitcanbasicdtls] a,[vw_apppost] b,[dbo].[trecruitcandidatesignup] c          
                            ,[dbo].[trecruitpostlocationmap] d    
                    WHERE            
                                     
                             bigfiveallow IN ( 'Completed', 'Reschedule' )           
                                      
       and a.candidateid=c.candidateid          
       and c.username=b.username  
    and b.postid=d.postid and b.locid=d.locid) a,           
                   [dbo].[trecuitpsycycotesttype] b           
            WHERE  a.bigfiveallow= Cast(b.[id] AS VARCHAR)           
                   AND  (@phytypeid is null or b.id = @phytypeid)   
				   and ((replace(replace(REPLACE(@postname, ' ', ''),'	',''),'		','') ) 
 is null or  (replace(replace(REPLACE(a.postname, ' ', ''),'	',''),'		','') =
	 replace(replace(REPLACE(@postname, ' ', ''),'	',''),'		','') )) 
       --and (@postname is null or a.postname = @postname )          
                   AND (@deptname is null or a.departmentdivision = @deptname)  
       and a.Confidentialpost='0'  
     union          
        SELECT Distinct [referenceno],           
                   [candidatename],           
                   [typename]           
            FROM   (SELECT [registrationnumber] [referenceno],           
                     b.[postname],          
          b.[deptname] departmentdivision, d.Confidentialpost, d.Confidentialpostlink,          
                           dbo.Candidate_FullName(a.[firstname],a.[middlename],a.[lastname]) [candidatename],         
                           CASE           
                             WHEN discrolallow = 'Completed' THEN 1           
                             WHEN discrolallow = 'Reschedule' THEN 1           
        WHEN discrolallow = 'Yes' THEN 10          
                             ELSE discrolallow           
                           END discrolallow,           
                           CASE           
                             WHEN conflictallow = 'Completed' THEN 2           
                             WHEN conflictallow = 'Reschedule' THEN 2           
        WHEN conflictallow = 'Yes' THEN 10          
                             ELSE conflictallow           
                           END conflictallow,           
                           CASE           
                             WHEN iqallow = 'Completed' THEN 3           
                             WHEN iqallow = 'Reschedule' THEN 3           
        WHEN iqallow = 'Yes' THEN 10          
                             ELSE iqallow           
                           END iqallow,           
                           CASE           
                             WHEN eqallow = 'Completed' THEN 4           
                             WHEN eqallow = 'Reschedule' THEN 4           
        WHEN eqallow = 'Yes' THEN 10          
                             ELSE eqallow           
                           END eqallow ,          
          CASE           
                             WHEN bigfiveallow = 'Completed' THEN 5           
                             WHEN bigfiveallow = 'Reschedule' THEN 5           
        WHEN bigfiveallow = 'Yes' THEN 10          
                             ELSE bigfiveallow           
                           END bigfiveallow ,          
         CASE           
                             WHEN firoballow = 'Completed' THEN 6           
                             WHEN firoballow = 'Reschedule' THEN 6           
        WHEN firoballow = 'Yes' THEN 10          
                             ELSE firoballow           
                           END firoballow,          
         CASE           
                             WHEN myersbriggsallow = 'Completed' THEN 7           
                             WHEN myersbriggsallow = 'Reschedule' THEN 7           
        WHEN myersbriggsallow = 'Yes' THEN 10          
                             ELSE myersbriggsallow           
                           END myersbriggsallow            
                    FROM   [trecruitcanbasicdtls] a,[vw_apppost] b,[dbo].[trecruitcandidatesignup] c          
                           ,[dbo].[trecruitpostlocationmap] d   
                    WHERE            
                                     
                             firoballow IN ( 'Completed', 'Reschedule' )           
                                      
       and a.candidateid=c.candidateid          
       and c.username=b.username       and b.postid=d.postid and b.locid=d.locid) a,           
                   [dbo].[trecuitpsycycotesttype] b           
            WHERE  a.firoballow= Cast(b.[id] AS VARCHAR)           
                    AND  (@phytypeid is null or b.id = @phytypeid)  
					and ((replace(replace(REPLACE(@postname, ' ', ''),'	',''),'		','') ) 
 is null or  (replace(replace(REPLACE(a.postname, ' ', ''),'	',''),'		','') =
	 replace(replace(REPLACE(@postname, ' ', ''),'	',''),'		','') )) 
       --and (@postname is null or a.postname = @postname )          
                   AND (@deptname is null or a.departmentdivision = @deptname)   
        and a.Confidentialpost='0'  
        union          
        SELECT Distinct [referenceno],           
                   [candidatename],           
                   [typename]           
            FROM   (SELECT [registrationnumber] [referenceno],           
                     b.[postname],          
          b.[deptname] departmentdivision,  d.Confidentialpost, d.Confidentialpostlink,                
                           dbo.Candidate_FullName(a.[firstname],a.[middlename],a.[lastname]) [candidatename],          
                           CASE           
                             WHEN discrolallow = 'Completed' THEN 1           
                             WHEN discrolallow = 'Reschedule' THEN 1           
        WHEN discrolallow = 'Yes' THEN 10          
                             ELSE discrolallow           
                           END discrolallow,           
                           CASE           
         WHEN conflictallow = 'Completed' THEN 2           
                             WHEN conflictallow = 'Reschedule' THEN 2           
        WHEN conflictallow = 'Yes' THEN 10          
                             ELSE conflictallow           
                           END conflictallow,           
                           CASE           
                             WHEN iqallow = 'Completed' THEN 3           
                             WHEN iqallow = 'Reschedule' THEN 3           
        WHEN iqallow = 'Yes' THEN 10          
                             ELSE iqallow           
                           END iqallow,           
     CASE           
                             WHEN eqallow = 'Completed' THEN 4           
                             WHEN eqallow = 'Reschedule' THEN 4           
        WHEN eqallow = 'Yes' THEN 10          
                             ELSE eqallow           
                           END eqallow ,          
          CASE           
                             WHEN bigfiveallow = 'Completed' THEN 5           
                             WHEN bigfiveallow = 'Reschedule' THEN 5           
        WHEN bigfiveallow = 'Yes' THEN 10          
                             ELSE bigfiveallow           
                           END bigfiveallow ,          
         CASE           
                             WHEN firoballow = 'Completed' THEN 6           
                             WHEN firoballow = 'Reschedule' THEN 6           
        WHEN firoballow = 'Yes' THEN 10          
                             ELSE firoballow           
                           END firoballow,          
         CASE           
                             WHEN myersbriggsallow = 'Completed' THEN 7           
                             WHEN myersbriggsallow = 'Reschedule' THEN 7           
        WHEN myersbriggsallow = 'Yes' THEN 10          
                             ELSE myersbriggsallow           
                           END myersbriggsallow            
                    FROM   [trecruitcanbasicdtls] a,[vw_apppost] b,[dbo].[trecruitcandidatesignup] c          
                            ,[dbo].[trecruitpostlocationmap] d    
                    WHERE            
                                     
                             myersbriggsallow IN ( 'Completed', 'Reschedule' )           
                                      
       and a.candidateid=c.candidateid          
       and c.username=b.username  
    and b.postid=d.postid and b.locid=d.locid) a,           
                   [dbo].[trecuitpsycycotesttype] b           
            WHERE  a.myersbriggsallow= Cast(b.[id] AS VARCHAR)    
                    AND  (@phytypeid is null or b.id = @phytypeid)        
      -- and (@postname is null or a.postname = @postname )      
	  and ((replace(replace(REPLACE(@postname, ' ', ''),'	',''),'		','') ) 
 is null or  (replace(replace(REPLACE(a.postname, ' ', ''),'	',''),'		','') =
	 replace(replace(REPLACE(@postname, ' ', ''),'	',''),'		','') )) 
    AND (@deptname is null or a.departmentdivision = @deptname)     
  and  a.Confidentialpost='0'  
       order by referenceno desc        
        END           
          
      IF @action = 'Selecttypewiseotcandidate'           
        BEGIN           
            SELECT Distinct [referenceno],           
                   [candidatename],           
                   [typename]           
            FROM   (SELECT             [registrationnumber][referenceno],           
                           dbo.Candidate_FullName(a.[firstname],a.[middlename],a.[lastname]) [candidatename],           
                           CASE           
                             WHEN discrolallow = 'Completed' THEN 1           
                             WHEN discrolallow = 'Reschedule' THEN 1           
        WHEN discrolallow = 'Yes' THEN 10          
                             ELSE discrolallow           
                           END discrolallow,           
                           CASE           
                             WHEN conflictallow = 'Completed' THEN 2           
                             WHEN conflictallow = 'Reschedule' THEN 2           
        WHEN conflictallow = 'Yes' THEN 10          
                             ELSE conflictallow           
                           END conflictallow,           
                           CASE           
                             WHEN iqallow = 'Completed' THEN 3           
                             WHEN iqallow = 'Reschedule' THEN 3           
        WHEN iqallow = 'Yes' THEN 10          
                             ELSE iqallow           
                           END iqallow,           
                           CASE           
                             WHEN eqallow = 'Completed' THEN 4           
                             WHEN eqallow = 'Reschedule' THEN 4           
        WHEN eqallow = 'Yes' THEN 10          
                             ELSE eqallow           
                           END eqallow,          
         CASE           
                             WHEN bigfiveallow = 'Completed' THEN 5           
     WHEN bigfiveallow = 'Reschedule' THEN 5           
        WHEN bigfiveallow = 'Yes' THEN 10          
                             ELSE bigfiveallow           
                           END bigfiveallow ,          
          CASE           
                             WHEN firoballow = 'Completed' THEN 6           
                             WHEN firoballow = 'Reschedule' THEN 6           
        WHEN firoballow = 'Yes' THEN 10          
                             ELSE firoballow           
                           END firoballow,          
         CASE           
                             WHEN myersbriggsallow = 'Completed' THEN 7           
                             WHEN myersbriggsallow = 'Reschedule' THEN 7           
        WHEN myersbriggsallow = 'Yes' THEN 10          
                             ELSE myersbriggsallow           
                           END myersbriggsallow             
                    FROM   [trecruitcanbasicdtls] a,[trecruitotherpost] b          
                    WHERE   discrolallow IN ( 'Completed', 'Reschedule' )           
                                      
       and a.candidateid=b.candidateid) a,           
                   [dbo].[trecuitpsycycotesttype] b           
       WHERE  a.discrolallow = Cast(b.[id] AS VARCHAR)           
                    AND  (@phytypeid is null or b.id = @phytypeid)        
          
       union          
          
       SELECT Distinct [referenceno],           
                   [candidatename],           
                   [typename]           
            FROM   (SELECT             [registrationnumber][referenceno],           
                           dbo.Candidate_FullName(a.[firstname],a.[middlename],a.[lastname]) [candidatename],           
                          CASE           
                             WHEN discrolallow = 'Completed' THEN 1           
                             WHEN discrolallow = 'Reschedule' THEN 1           
        WHEN discrolallow = 'Yes' THEN 10          
                             ELSE discrolallow           
                           END discrolallow,           
                           CASE           
                             WHEN conflictallow = 'Completed' THEN 2           
                             WHEN conflictallow = 'Reschedule' THEN 2           
        WHEN conflictallow = 'Yes' THEN 10          
  ELSE conflictallow           
                           END conflictallow,           
                           CASE           
                             WHEN iqallow = 'Completed' THEN 3           
                             WHEN iqallow = 'Reschedule' THEN 3           
        WHEN iqallow = 'Yes' THEN 10          
                             ELSE iqallow           
                           END iqallow,           
                           CASE           
                             WHEN eqallow = 'Completed' THEN 4           
                             WHEN eqallow = 'Reschedule' THEN 4           
        WHEN eqallow = 'Yes' THEN 10          
                             ELSE eqallow           
                           END eqallow ,          
         CASE           
                             WHEN bigfiveallow = 'Completed' THEN 5           
                             WHEN bigfiveallow = 'Reschedule' THEN 5           
        WHEN bigfiveallow = 'Yes' THEN 10          
                             ELSE bigfiveallow           
                           END bigfiveallow,          
          CASE           
                             WHEN firoballow = 'Completed' THEN 6           
                             WHEN firoballow = 'Reschedule' THEN 6           
        WHEN firoballow = 'Yes' THEN 10          
                             ELSE firoballow           
                           END firoballow,          
         CASE           
                             WHEN myersbriggsallow = 'Completed' THEN 7           
                             WHEN myersbriggsallow = 'Reschedule' THEN 7           
        WHEN myersbriggsallow = 'Yes' THEN 10          
                             ELSE myersbriggsallow           
                           END myersbriggsallow             
                    FROM  [trecruitcanbasicdtls] a,[trecruitotherpost] b          
                    WHERE    conflictallow IN ( 'Completed', 'Reschedule' )           
                                     
       and a.candidateid=b.candidateid) a,           
                   [dbo].[trecuitpsycycotesttype] b           
            WHERE  a.conflictallow = Cast(b.[id] AS VARCHAR)           
                   AND  (@phytypeid is null or b.id = @phytypeid)        
       union          
          
       SELECT Distinct [referenceno],           
                   [candidatename],           
                   [typename]           
            FROM   (SELECT  [registrationnumber][referenceno],           
                           dbo.Candidate_FullName(a.[firstname],a.[middlename],a.[lastname]) [candidatename],        
                           CASE           
                             WHEN discrolallow = 'Completed' THEN 1           
                             WHEN discrolallow = 'Reschedule' THEN 1           
        WHEN discrolallow = 'Yes' THEN 10          
                             ELSE discrolallow           
                           END discrolallow,           
                           CASE           
                             WHEN conflictallow = 'Completed' THEN 2           
                             WHEN conflictallow = 'Reschedule' THEN 2           
        WHEN conflictallow = 'Yes' THEN 10          
                             ELSE conflictallow           
                           END conflictallow,           
                           CASE         
                             WHEN iqallow = 'Completed' THEN 3           
                             WHEN iqallow = 'Reschedule' THEN 3           
        WHEN iqallow = 'Yes' THEN 10          
                             ELSE iqallow           
                           END iqallow,           
                           CASE           
                             WHEN eqallow = 'Completed' THEN 4           
                             WHEN eqallow = 'Reschedule' THEN 4           
        WHEN eqallow = 'Yes' THEN 10          
                             ELSE eqallow           
                           END eqallow ,          
         CASE           
                             WHEN bigfiveallow = 'Completed' THEN 5           
                             WHEN bigfiveallow = 'Reschedule' THEN 5           
        WHEN bigfiveallow = 'Yes' THEN 10          
                             ELSE bigfiveallow           
                           END bigfiveallow ,          
          CASE           
                             WHEN firoballow = 'Completed' THEN 6           
                   WHEN firoballow = 'Reschedule' THEN 6           
        WHEN firoballow = 'Yes' THEN 10          
                             ELSE firoballow           
                            END firoballow ,          
       CASE           
                             WHEN myersbriggsallow = 'Completed' THEN 7           
                             WHEN myersbriggsallow = 'Reschedule' THEN 7           
        WHEN myersbriggsallow = 'Yes' THEN 10          
                             ELSE myersbriggsallow           
                           END myersbriggsallow           
                    FROM   [trecruitcanbasicdtls] a,[trecruitotherpost] b          
                    WHERE    eqallow IN ( 'Completed', 'Reschedule' )           
                                     
       and a.candidateid=b.candidateid) a,           
                   [dbo].[trecuitpsycycotesttype] b           
            WHERE  a.eqallow = Cast(b.[id] AS VARCHAR)           
                    AND  (@phytypeid is null or b.id = @phytypeid)        
          
       union          
          
       SELECT Distinct [referenceno],           
                   [candidatename],           
                   [typename]           
            FROM   (SELECT  [registrationnumber][referenceno],           
                           dbo.Candidate_FullName(a.[firstname],a.[middlename],a.[lastname]) [candidatename],          
                           CASE     
                             WHEN discrolallow = 'Completed' THEN 1           
                             WHEN discrolallow = 'Reschedule' THEN 1           
        WHEN discrolallow = 'Yes' THEN 10          
                             ELSE discrolallow           
                           END discrolallow,           
                           CASE           
                             WHEN conflictallow = 'Completed' THEN 2           
                             WHEN conflictallow = 'Reschedule' THEN 2           
        WHEN conflictallow = 'Yes' THEN 10          
                             ELSE conflictallow           
                           END conflictallow,           
                           CASE           
                             WHEN iqallow = 'Completed' THEN 3           
                             WHEN iqallow = 'Reschedule' THEN 3           
        WHEN iqallow = 'Yes' THEN 10          
                             ELSE iqallow           
                           END iqallow,           
                           CASE           
               WHEN eqallow = 'Completed' THEN 4           
                             WHEN eqallow = 'Reschedule' THEN 4           
        WHEN eqallow = 'Yes' THEN 10          
                             ELSE eqallow           
                           END eqallow ,          
         CASE           
                             WHEN bigfiveallow = 'Completed' THEN 5           
       WHEN bigfiveallow = 'Reschedule' THEN 5           
        WHEN bigfiveallow = 'Yes' THEN 10          
               ELSE bigfiveallow           
                           END bigfiveallow ,          
          CASE           
                             WHEN firoballow = 'Completed' THEN 6           
                             WHEN firoballow = 'Reschedule' THEN 6           
        WHEN firoballow = 'Yes' THEN 10          
                             ELSE firoballow           
                           END firoballow,          
         CASE           
                             WHEN myersbriggsallow = 'Completed' THEN 7           
                             WHEN myersbriggsallow = 'Reschedule' THEN 7           
        WHEN myersbriggsallow = 'Yes' THEN 10          
                             ELSE myersbriggsallow           
                           END myersbriggsallow            
                    FROM   [trecruitcanbasicdtls] a,[trecruitotherpost] b          
                    WHERE    iqallow IN ( 'Completed', 'Reschedule' )           
                                     
       and a.candidateid=b.candidateid) a,           
                   [dbo].[trecuitpsycycotesttype] b           
            WHERE  a.iqallow = Cast(b.[id] AS VARCHAR)           
                    AND  (@phytypeid is null or b.id = @phytypeid)        
   union          
          
       SELECT Distinct [referenceno],           
                   [candidatename],           
                   [typename]           
            FROM   (SELECT  [registrationnumber][referenceno],           
                           dbo.Candidate_FullName(a.[firstname],a.[middlename],a.[lastname]) [candidatename],          
                           CASE           
                             WHEN discrolallow = 'Completed' THEN 1           
                             WHEN discrolallow = 'Reschedule' THEN 1           
        WHEN discrolallow = 'Yes' THEN 10          
                             ELSE discrolallow           
                           END discrolallow,           
                           CASE           
                             WHEN conflictallow = 'Completed' THEN 2           
                             WHEN conflictallow = 'Reschedule' THEN 2           
        WHEN conflictallow = 'Yes' THEN 10          
                             ELSE conflictallow           
                           END conflictallow,           
                           CASE           
                             WHEN iqallow = 'Completed' THEN 3           
                             WHEN iqallow = 'Reschedule' THEN 3           
        WHEN iqallow = 'Yes' THEN 10          
                             ELSE iqallow           
                           END iqallow,           
                           CASE           
                             WHEN eqallow = 'Completed' THEN 4           
                             WHEN eqallow = 'Reschedule' THEN 4           
        WHEN eqallow = 'Yes' THEN 10          
                             ELSE eqallow           
                           END eqallow ,          
         CASE           
                             WHEN bigfiveallow = 'Completed' THEN 5           
                             WHEN bigfiveallow = 'Reschedule' THEN 5           
        WHEN bigfiveallow = 'Yes' THEN 10          
                             ELSE bigfiveallow           
                           END bigfiveallow ,          
          CASE           
                             WHEN firoballow = 'Completed' THEN 6           
                             WHEN firoballow = 'Reschedule' THEN 6           
        WHEN firoballow = 'Yes' THEN 10          
                             ELSE firoballow           
                           END firoballow,          
         CASE           
                             WHEN myersbriggsallow = 'Completed' THEN 7           
                             WHEN myersbriggsallow = 'Reschedule' THEN 7           
        WHEN myersbriggsallow = 'Yes' THEN 10          
                             ELSE myersbriggsallow           
                           END myersbriggsallow            
                    FROM   [trecruitcanbasicdtls] a,[trecruitotherpost] b          
                    WHERE  bigfiveallow IN ( 'Completed', 'Reschedule' )           
                                     
       and a.candidateid=b.candidateid) a,           
             [dbo].[trecuitpsycycotesttype] b           
            WHERE  a.bigfiveallow = Cast(b.[id] AS VARCHAR)           
                   AND  (@phytypeid is null or b.id = @phytypeid)        
        union          
          
       SELECT Distinct [referenceno],           
                   [candidatename],           
                   [typename]           
            FROM   (SELECT  [registrationnumber][referenceno],           
                           dbo.Candidate_FullName(a.[firstname],a.[middlename],a.[lastname]) [candidatename],           
                           CASE           
                             WHEN discrolallow = 'Completed' THEN 1           
                             WHEN discrolallow = 'Reschedule' THEN 1           
        WHEN discrolallow = 'Yes' THEN 10          
                             ELSE discrolallow           
                           END discrolallow,           
                           CASE           
                             WHEN conflictallow = 'Completed' THEN 2           
                             WHEN conflictallow = 'Reschedule' THEN 2           
        WHEN conflictallow = 'Yes' THEN 10          
                             ELSE conflictallow           
                           END conflictallow,           
                           CASE           
                             WHEN iqallow = 'Completed' THEN 3           
                             WHEN iqallow = 'Reschedule' THEN 3           
        WHEN iqallow = 'Yes' THEN 10          
                             ELSE iqallow           
                           END iqallow,          
                           CASE           
                             WHEN eqallow = 'Completed' THEN 4           
                             WHEN eqallow = 'Reschedule' THEN 4           
        WHEN eqallow = 'Yes' THEN 10          
                             ELSE eqallow           
                           END eqallow ,          
         CASE           
                             WHEN bigfiveallow = 'Completed' THEN 5           
                             WHEN bigfiveallow = 'Reschedule' THEN 5           
        WHEN bigfiveallow = 'Yes' THEN 10          
                             ELSE bigfiveallow           
                           END bigfiveallow ,          
          CASE           
                             WHEN firoballow = 'Completed' THEN 6         
                             WHEN firoballow = 'Reschedule' THEN 6           
        WHEN firoballow = 'Yes' THEN 10          
                             ELSE firoballow           
                           END firoballow,          
         CASE           
                             WHEN myersbriggsallow = 'Completed' THEN 7           
                             WHEN myersbriggsallow = 'Reschedule' THEN 7           
        WHEN myersbriggsallow = 'Yes' THEN 10          
                             ELSE myersbriggsallow           
                           END myersbriggsallow            
                    FROM   [trecruitcanbasicdtls] a,[trecruitotherpost] b          
                    WHERE    firoballow IN ( 'Completed', 'Reschedule' )           
                                     
       and a.candidateid=b.candidateid) a,           
                   [dbo].[trecuitpsycycotesttype] b           
            WHERE  a.firoballow = Cast(b.[id] AS VARCHAR)           
                    AND  (@phytypeid is null or b.id = @phytypeid)        
           union          
          
       SELECT Distinct [referenceno],           
                   [candidatename],     
                   [typename]           
            FROM   (SELECT  [registrationnumber][referenceno],           
                           dbo.Candidate_FullName(a.[firstname],a.[middlename],a.[lastname]) [candidatename],          
                           CASE           
                             WHEN discrolallow = 'Completed' THEN 1           
                             WHEN discrolallow = 'Reschedule' THEN 1           
        WHEN discrolallow = 'Yes' THEN 10          
                             ELSE discrolallow           
                           END discrolallow,           
                           CASE           
                             WHEN conflictallow = 'Completed' THEN 2           
          WHEN conflictallow = 'Reschedule' THEN 2           
        WHEN conflictallow = 'Yes' THEN 10          
                             ELSE conflictallow           
                           END conflictallow,           
                           CASE           
                            WHEN iqallow = 'Completed' THEN 3           
                             WHEN iqallow = 'Reschedule' THEN 3           
        WHEN iqallow = 'Yes' THEN 10          
                             ELSE iqallow           
                           END iqallow,           
                           CASE           
                             WHEN eqallow = 'Completed' THEN 4           
                             WHEN eqallow = 'Reschedule' THEN 4           
        WHEN eqallow = 'Yes' THEN 10          
                             ELSE eqallow           
                           END eqallow ,          
         CASE           
                             WHEN bigfiveallow = 'Completed' THEN 5           
                             WHEN bigfiveallow = 'Reschedule' THEN 5           
        WHEN bigfiveallow = 'Yes' THEN 10          
                             ELSE bigfiveallow           
                           END bigfiveallow ,          
          CASE           
                             WHEN firoballow = 'Completed' THEN 6           
                             WHEN firoballow = 'Reschedule' THEN 6           
        WHEN firoballow = 'Yes' THEN 10          
                             ELSE firoballow           
                           END firoballow,          
         CASE           
                             WHEN myersbriggsallow = 'Completed' THEN 7           
                             WHEN myersbriggsallow = 'Reschedule' THEN 7           
    WHEN myersbriggsallow = 'Yes' THEN 10          
                             ELSE myersbriggsallow           
                           END myersbriggsallow            
                    FROM   [trecruitcanbasicdtls] a,[trecruitotherpost] b          
                    WHERE    myersbriggsallow IN ( 'Completed', 'Reschedule' )           
                                     
       and a.candidateid=b.candidateid) a,           
                   [dbo].[trecuitpsycycotesttype] b           
            WHERE  a.myersbriggsallow = Cast(b.[id] AS VARCHAR)           
                    AND  (@phytypeid is null or b.id = @phytypeid)        
        
       order by referenceno desc        
        END           
          
      IF @action = 'Selectquesans'           
        BEGIN           
            SELECT [disquestype],           
                   [quesserialno],           
                   [question],           
                   f.[answer]           
            FROM   [trecruitdiscrolcandidatedtls] a,           
                   [dbo].[trecruitdiscrolqusdtls] b,           
                   [dbo].[trecruitdiscrolquestype] c,           
                   [dbo].[trecruitdiscrolansdtls]f,           
                   [dbo].[trecruitcanbasicdtls] d,           
                   [dbo].[languages]e           
            WHERE  a.[languageid] = b.[languageid]           
                   AND a.[questionid] = b.[quesserialno]           
                   AND b.[disquestypeid] = c.[id]           
                AND a.[candidateid] = d.[candidateid]           
                   AND a.[languageid] = e.[id]           
                   AND a.answer = f.number           
                   AND a.[languageid] = f.[languageid]           
                   AND a.candidateid = @candidateid           
                   AND [candidateattemexam] = @candidateattemexam           
            ORDER  BY [quesserialno]           
        END           
          
      IF @action = 'Reschedule'           
        BEGIN           
            --SELECT @candiscrolallow = [discrolallow]           
            --FROM   [Recruitment].[dbo].[trecruittraker]           
            --WHERE  [candidateid] = @candidateid           
            --GROUP  BY [discrolallow],           
            --          [conflictallow],           
            --          [iqallow],           
            --          [eqallow]           
          
   SELECT @candiscrolallow = [discrolallow]           
            FROM   [dbo].[trecruitcanbasicdtls]          
            WHERE  [candidateid] = @candidateid           
            GROUP  BY [discrolallow],           
                      [conflictallow],           
                      [iqallow],           
                      [eqallow]           
          
                       
            IF @candiscrolallow = 'Completed'           
              BEGIN           
                  UPDATE [trecruitcanbasicdtls]           
                  SET    [discrolallow] = 'Reschedule'           
                  WHERE  [candidateid] = @candidateid           
              END           
            ELSE           
              BEGIN           
                  SET @message=1           
              END           
        END           
          
      IF @action = 'SELECTEXAMNO'           
    BEGIN           
            SELECT [attemexam],           
                   CASE           
                     WHEN [attemexam] = 1 THEN Cast('1st Exam' AS VARCHAR)           
                     WHEN [attemexam] = 2 THEN Cast('2nd Exam'AS VARCHAR)           
                     WHEN [attemexam] = 3 THEN Cast('3rd Exam'AS VARCHAR)           
                     ELSE Cast([attemexam]AS VARCHAR) + '' + 'th Exam'           
                   END [attemexamtext]           
            FROM   [trecruitdiscrolexamdtls]           
            WHERE  candidateid = @candidateid           
                   AND finalsubmit = 'Yes'           
            ORDER  BY [attemexam]           
        END           
          
      IF @action = 'Selecttypewisetotalno'           
        BEGIN           
            SELECT c.[disquestype],           
                   a.questionid,           
                   a.answer,           
                   totscore           
            FROM   [trecruitdiscrolcandidatedtls] a,           
                   [dbo].[trecruitdiscrolqusdtls] b,           
                   [dbo].[trecruitdiscrolquestype] c,           
                   [dbo].[trecruitdiscrolansdtls]f,           
                   [dbo].[trecruitcanbasicdtls] d,           
                   [dbo].[languages]e,           
                  (SELECT c.[disquestype],           
                           Sum (a.answer)totscore           
                    FROM   [trecruitdiscrolcandidatedtls] a,           
                           [dbo].[trecruitdiscrolqusdtls] b,           
                           [dbo].[trecruitdiscrolquestype] c,           
                           [dbo].[trecruitdiscrolansdtls]f,           
                           [dbo].[trecruitcanbasicdtls] d,           
                           [dbo].[languages]e           
                    WHERE  a.[languageid] = b.[languageid]           
                           AND a.[questionid] = b.[quesserialno]           
                           AND b.[disquestypeid] = c.[id]           
                           AND a.[candidateid] = d.[candidateid]           
                           AND a.[languageid] = e.[id]   
                            AND a.answer = f.[number]          
         and a.[languageid]=f.[languageid]             
                           AND a.candidateid = @candidateid           
                           AND [candidateattemexam] = @candidateattemexam           
                    GROUP  BY c.[disquestype]) z           
            WHERE  a.[languageid] = b.[languageid]           
                   AND a.[questionid] = b.[quesserialno]           
                   AND b.[disquestypeid] = c.[id]           
                   AND a.[candidateid] = d.[candidateid]           
                   AND a.[languageid] = e.[id]           
                    AND a.answer = f.[number]          
     and a.[languageid]=f.[languageid]             
                   AND a.candidateid = @candidateid           
                   AND [candidateattemexam] = @candidateattemexam           
                   AND c.[disquestype] = z.[disquestype]           
            ORDER  BY [disquestype]           
        END           
          
      IF @action = 'Discrolgraph'           
        BEGIN           
            SELECT ( d.totscore * 1.363636 ) TIGERfinalscore,           
                   ( a.totscore * 2 )        CHAMELEONfinalscore,           
                   ( e.totscore * 2.1428 )   TURTLEfinalscore,           
                   ( b.totscore * 1.363636 ) EAGLEfinalscore,           
                   ( a.totscore * 2 )        SALMONfinalscore           
            FROM   (SELECT c.[disquestype],           
                           a.candidateid,           
                           Sum (a.answer)totscore           
                    FROM  [trecruitdiscrolcandidatedtls] a,           
                           [dbo].[trecruitdiscrolqusdtls] b,           
                           [dbo].[trecruitdiscrolquestype] c,           
                           [dbo].[trecruitdiscrolansdtls]f,           
                           [dbo].[trecruitcanbasicdtls] d,           
                           [dbo].[languages]e           
                    WHERE  a.[languageid] = b.[languageid]           
                           AND a.[questionid] = b.[quesserialno]           
                           AND b.[disquestypeid] = c.[id]           
                           AND a.[candidateid] = d.[candidateid]           
                           AND a.[languageid] = e.[id]           
                            AND a.answer = f.[number]          
         and a.[languageid]=f.[languageid]              
                           AND a.candidateid = @candidateid           
                           AND [candidateattemexam] = @candidateattemexam           
                           AND c.[disquestype] = 'CHAMELEON'           
                    GROUP  BY c.[disquestype],           
                              a.candidateid) a,           
                   (SELECT c.[disquestype],           
                           a.candidateid,           
                           Sum (a.answer)totscore           
                    FROM   [trecruitdiscrolcandidatedtls] a,           
                           [dbo].[trecruitdiscrolqusdtls] b,           
                           [dbo].[trecruitdiscrolquestype] c,           
 [dbo].[trecruitdiscrolansdtls]f,           
                           [dbo].[trecruitcanbasicdtls] d,           
                           [dbo].[languages]e           
                    WHERE  a.[languageid] = b.[languageid]           
                           AND a.[questionid] = b.[quesserialno]           
                           AND b.[disquestypeid] = c.[id]           
                           AND a.[candidateid] = d.[candidateid]           
                           AND a.[languageid] = e.[id]           
                            AND a.answer = f.[number]          
         and a.[languageid]=f.[languageid]             
                           AND a.candidateid = @candidateid           
                           AND [candidateattemexam] = @candidateattemexam           
                           AND c.[disquestype] = 'EAGLE'           
                    GROUP  BY c.[disquestype],           
                              a.candidateid) b,           
                   (SELECT c.[disquestype],           
                           a.candidateid,           
                           Sum (a.answer)totscore           
                    FROM   [trecruitdiscrolcandidatedtls] a,           
                           [dbo].[trecruitdiscrolqusdtls] b,           
                           [dbo].[trecruitdiscrolquestype] c,           
                           [dbo].[trecruitdiscrolansdtls]f,           
                           [dbo].[trecruitcanbasicdtls] d,           
                           [dbo].[languages]e           
                    WHERE  a.[languageid] = b.[languageid]           
                           AND a.[questionid] = b.[quesserialno]           
                           AND b.[disquestypeid] = c.[id]           
                           AND a.[candidateid] = d.[candidateid]           
                           AND a.[languageid] = e.[id]           
                            AND a.answer = f.[number]          
         and a.[languageid]=f.[languageid]             
                           AND a.candidateid = @candidateid           
                           AND [candidateattemexam] = @candidateattemexam           
                           AND c.[disquestype] = 'SALMON'           
                    GROUP  BY c.[disquestype],           
                              a.candidateid) c,           
    (SELECT c.[disquestype],           
                           a.candidateid,           
                           Sum (a.answer)totscore           
                    FROM   [trecruitdiscrolcandidatedtls] a,           
                           [dbo].[trecruitdiscrolqusdtls] b,           
                           [dbo].[trecruitdiscrolquestype] c,           
                           [dbo].[trecruitdiscrolansdtls]f,           
                           [dbo].[trecruitcanbasicdtls] d,           
                           [dbo].[languages]e           
                    WHERE  a.[languageid] = b.[languageid]           
                           AND a.[questionid] = b.[quesserialno]           
                           AND b.[disquestypeid] = c.[id]           
                           AND a.[candidateid] = d.[candidateid]           
                           AND a.[languageid] = e.[id]           
                            AND a.answer = f.[number]          
         and a.[languageid]=f.[languageid]             
                           AND a.candidateid = @candidateid           
                           AND [candidateattemexam] = @candidateattemexam           
                           AND c.[disquestype] = 'TIGER'           
                    GROUP  BY c.[disquestype],           
                              a.candidateid) d,           
                   (SELECT c.[disquestype],           
                           a.candidateid,           
                           Sum (a.answer)totscore           
                    FROM   [trecruitdiscrolcandidatedtls] a,           
                           [dbo].[trecruitdiscrolqusdtls] b,           
                           [dbo].[trecruitdiscrolquestype] c,           
    [dbo].[trecruitdiscrolansdtls]f,           
                           [dbo].[trecruitcanbasicdtls] d,           
                           [dbo].[languages]e           
                    WHERE  a.[languageid] = b.[languageid]           
                           AND a.[questionid] = b.[quesserialno]           
                           AND b.[disquestypeid] = c.[id]           
                           AND a.[candidateid] = d.[candidateid]           
              AND a.[languageid] = e.[id]           
                            AND a.answer = f.[number]          
         and a.[languageid]=f.[languageid]             
                           AND a.candidateid = @candidateid           
                           AND [candidateattemexam] = @candidateattemexam           
                           AND c.[disquestype] = 'TURTLE'           
                    GROUP  BY c.[disquestype],           
                              a.candidateid) e           
            WHERE  a.candidateid = b.candidateid           
                   AND a.candidateid = c.candidateid           
                   AND a.candidateid = d.candidateid           
                   AND a.candidateid = e.candidateid           
        END           
          
      IF @action = 'Activeinactiveresbutton'           
        BEGIN           
            SELECT           
                   a.[discrolallow]           
            FROM   [dbo].[trecruitcanbasicdtls] a                          
            WHERE a.candidateid = @candidateid           
        END           
  END 
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: Languages, trecruitcanbasicdtls, trecruitcandidatesignup, trecruitdiscrolansdtls, trecruitdiscrolcandidatedtls, trecruitdiscrolexamdtls, trecruitdiscrolquestype, trecruitdiscrolqusdtls, trecruitotherpost, trecruittraker, trecuitpsycycotesttype */
/****** Object:  StoredProcedure [dbo].[procdishrdtls_NEW]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
      
/****** Script for SelectTopNRows command from SSMS  ******/       
CREATE PROC [dbo].[procdishrdtls_NEW] @action             VARCHAR(100)=NULL,       
                                 @phytypeid          INT=NULL,       
                                 @postname           VARCHAR(500)=NULL,       
                                 @deptname           VARCHAR(500)=NULL,       
                                 @candidateattemexam INT=NULL,       
                                 @registrationnumber VARCHAR(200)=NULL,       
                                 @discrolallow       VARCHAR(200)=NULL,       
                                 @Message            VARCHAR(200)=NULL       
AS       
    DECLARE @candidateid INT       
    DECLARE @candiscrolallow VARCHAR(200)       
      
  BEGIN       
    
  if(@phytypeid is null or @phytypeid=0)    
  begin    
  set    
  @phytypeid=null    
  end    
  if(@postname is null or @postname='0')    
  begin    
  set    
  @postname=null    
  end    
  if(@registrationnumber is null or @registrationnumber='0')    
  begin    
  set    
  @registrationnumber=null    
  end    
    
      SELECT @candidateid = candidateid       
      FROM   [dbo].[trecruitcanbasicdtls]       
      WHERE  registrationnumber = @registrationnumber       
      
        
      
      
      IF @action = 'Selecttypewisecandidate'       
        BEGIN       
                
      
        SELECT [referenceno],       
                           [candidatename],       
                           [typename]       
            FROM   (SELECT [registrationnumber] [referenceno],       
                     b.[postname],      
          b.[deptname] departmentdivision,      
                           a.[firstname]+' '+a.[middlename]+' '+a.[lastname] [candidatename],       
                           CASE       
                             WHEN discrolallow = 'Completed' THEN 1       
                             WHEN discrolallow = 'Reschedule' THEN 1       
        WHEN discrolallow = 'Yes' THEN 10      
                             ELSE discrolallow       
                           END discrolallow,       
                           CASE       
                             WHEN conflictallow = 'Completed' THEN 2       
                             WHEN conflictallow = 'Reschedule' THEN 2       
        WHEN conflictallow = 'Yes' THEN 10      
                             ELSE conflictallow       
                           END conflictallow,       
                           CASE       
                             WHEN iqallow = 'Completed' THEN 3       
                             WHEN iqallow = 'Reschedule' THEN 3       
        WHEN iqallow = 'Yes' THEN 10      
                             ELSE iqallow       
                           END iqallow,       
                           CASE       
                             WHEN eqallow = 'Completed' THEN 4       
                             WHEN eqallow = 'Reschedule' THEN 4       
        WHEN eqallow = 'Yes' THEN 10      
                             ELSE eqallow       
                           END eqallow ,      
         CASE       
                             WHEN bigfiveallow = 'Completed' THEN 5       
                             WHEN bigfiveallow = 'Reschedule' THEN 5       
        WHEN bigfiveallow = 'Yes' THEN 10      
                             ELSE bigfiveallow      
        end bigfiveallow,      
        CASE       
                             WHEN firoballow = 'Completed' THEN 6       
                             WHEN firoballow = 'Reschedule' THEN 6       
        WHEN firoballow = 'Yes' THEN 10      
                             ELSE firoballow       
                           END firoballow,       
        CASE       
                             WHEN myersbriggsallow = 'Completed' THEN 7       
                             WHEN myersbriggsallow = 'Reschedule' THEN 7       
        WHEN myersbriggsallow = 'Yes' THEN 10      
                             ELSE myersbriggsallow       
                           END myersbriggsallow       
                    FROM   [trecruitcanbasicdtls] a,[vw_apppost] b,[dbo].[trecruitcandidatesignup] c      
      
                    WHERE        
         discrolallow IN ( 'Completed', 'Reschedule' )       
                                  
       and a.candidateid=c.candidateid      
       and c.username=b.username) a,       
                   [dbo].[trecuitpsycycotesttype] b       
            WHERE  a.discrolallow = Cast(b.[id] AS VARCHAR)       
                   AND  (@phytypeid is null or b.id = @phytypeid)    
        and ((replace(replace(REPLACE(@postname, ' ', ''),' ',''),'  ','') )   
 is null or  (replace(replace(REPLACE(a.postname, ' ', ''),' ',''),'  ','') =  
  replace(replace(REPLACE(@postname, ' ', ''),' ',''),'  ','') )) 
                   AND (@deptname is null or a.departmentdivision = @deptname)       
       and (@registrationnumber is null or a.referenceno=@registrationnumber)    
          
       union      
        SELECT [referenceno],       
                   [candidatename],       
                   [typename]       
            FROM   (SELECT [registrationnumber] [referenceno],       
                     b.[postname],      
          b.[deptname] departmentdivision,      
                           a.[firstname]+' '+a.[middlename]+' '+a.[lastname] [candidatename],       
                           CASE       
                             WHEN discrolallow = 'Completed' THEN 1       
                             WHEN discrolallow = 'Reschedule' THEN 1       
        WHEN discrolallow = 'Yes' THEN 10      
                             ELSE discrolallow       
                           END discrolallow,       
                           CASE       
                             WHEN conflictallow = 'Completed' THEN 2       
                             WHEN conflictallow = 'Reschedule' THEN 2       
        WHEN conflictallow = 'Yes' THEN 10      
                             ELSE conflictallow       
                           END conflictallow,       
                           CASE       
                             WHEN iqallow = 'Completed' THEN 3       
                             WHEN iqallow = 'Reschedule' THEN 3       
        WHEN iqallow = 'Yes' THEN 10      
                             ELSE iqallow       
                           END iqallow,       
                           CASE       
                             WHEN eqallow = 'Completed' THEN 4       
                             WHEN eqallow = 'Reschedule' THEN 4       
        WHEN eqallow = 'Yes' THEN 10      
                             ELSE eqallow       
                           END eqallow ,      
          CASE       
                             WHEN bigfiveallow = 'Completed' THEN 5       
                             WHEN bigfiveallow = 'Reschedule' THEN 5       
        WHEN bigfiveallow = 'Yes' THEN 10      
                             ELSE bigfiveallow       
                           END bigfiveallow,      
         CASE       
                             WHEN firoballow = 'Completed' THEN 6       
                             WHEN firoballow = 'Reschedule' THEN 6       
        WHEN firoballow = 'Yes' THEN 10      
                             ELSE firoballow       
                           END firoballow,      
         CASE       
                             WHEN myersbriggsallow = 'Completed' THEN 7       
                             WHEN myersbriggsallow = 'Reschedule' THEN 7       
        WHEN myersbriggsallow = 'Yes' THEN 10      
                             ELSE myersbriggsallow       
                           END myersbriggsallow         
                    FROM   [trecruitcanbasicdtls] a,[vw_apppost] b,[dbo].[trecruitcandidatesignup] c      
      
                    WHERE        
                                 
                             conflictallow IN ( 'Completed', 'Reschedule' )       
                                  
       and a.candidateid=c.candidateid      
       and c.username=b.username) a,       
                   [dbo].[trecuitpsycycotesttype] b       
            WHERE  a.conflictallow= Cast(b.[id] AS VARCHAR)       
                 AND  (@phytypeid is null or b.id = @phytypeid)    
       and ((replace(replace(REPLACE(@postname, ' ', ''),' ',''),'  ','') )   
 is null or  (replace(replace(REPLACE(a.postname, ' ', ''),' ',''),'  ','') =  
  replace(replace(REPLACE(@postname, ' ', ''),' ',''),'  ','') ))  
                   AND (@deptname is null or a.departmentdivision = @deptname)       
       and (@registrationnumber is null or a.referenceno=@registrationnumber)    
       union      
        SELECT [referenceno],       
[candidatename],       
                   [typename]       
            FROM   (SELECT [registrationnumber] [referenceno],       
                     b.[postname],      
          b.[deptname] departmentdivision,      
                           a.[firstname]+' '+a.[middlename]+' '+a.[lastname] [candidatename],       
                           CASE       
                             WHEN discrolallow = 'Completed' THEN 1       
                             WHEN discrolallow = 'Reschedule' THEN 1       
        WHEN discrolallow = 'Yes' THEN 10      
                             ELSE discrolallow       
                           END discrolallow,       
                           CASE       
                             WHEN conflictallow = 'Completed' THEN 2       
                             WHEN conflictallow = 'Reschedule' THEN 2       
        WHEN conflictallow = 'Yes' THEN 10      
                             ELSE conflictallow       
           END conflictallow,       
                           CASE       
                             WHEN iqallow = 'Completed' THEN 3       
                             WHEN iqallow = 'Reschedule' THEN 3       
        WHEN iqallow = 'Yes' THEN 10      
                             ELSE iqallow       
                           END iqallow,       
                           CASE       
                             WHEN eqallow = 'Completed' THEN 4       
                             WHEN eqallow = 'Reschedule' THEN 4       
        WHEN eqallow = 'Yes' THEN 10      
                             ELSE eqallow       
                           END eqallow ,      
          CASE       
                             WHEN bigfiveallow = 'Completed' THEN 5       
                             WHEN bigfiveallow = 'Reschedule' THEN 5       
        WHEN bigfiveallow = 'Yes' THEN 10      
                             ELSE bigfiveallow       
                           END bigfiveallow,      
         CASE       
                             WHEN firoballow = 'Completed' THEN 6       
                             WHEN firoballow = 'Reschedule' THEN 6       
        WHEN firoballow = 'Yes' THEN 10      
                             ELSE firoballow       
                           END firoballow,      
         CASE       
                             WHEN myersbriggsallow = 'Completed' THEN 7       
                             WHEN myersbriggsallow = 'Reschedule' THEN 7       
        WHEN myersbriggsallow = 'Yes' THEN 10      
                             ELSE myersbriggsallow       
                           END myersbriggsallow         
                    FROM   [trecruitcanbasicdtls] a,[vw_apppost] b,[dbo].[trecruitcandidatesignup] c      
      
                    WHERE        
                                 
                             eqallow IN ( 'Completed', 'Reschedule' )       
                                  
       and a.candidateid=c.candidateid      
       and c.username=b.username) a,       
                   [dbo].[trecuitpsycycotesttype] b       
            WHERE  a.eqallow= Cast(b.[id] AS VARCHAR)       
                  AND  (@phytypeid is null or b.id = @phytypeid)    
       and (@postname is null or a.postname = @postname )      
                   AND (@deptname is null or a.departmentdivision = @deptname)       
       and (@registrationnumber is null or a.referenceno=@registrationnumber)    
      
       union      
        SELECT [referenceno],       
                   [candidatename],       
                   [typename]       
            FROM   (SELECT [registrationnumber] [referenceno],       
                     b.[postname],      
          b.[deptname] departmentdivision,      
                           a.[firstname]+' '+a.[middlename]+' '+a.[lastname] [candidatename],       
                           CASE       
                             WHEN discrolallow = 'Completed' THEN 1       
                             WHEN discrolallow = 'Reschedule' THEN 1       
        WHEN discrolallow = 'Yes' THEN 10      
                             ELSE discrolallow       
                           END discrolallow,       
                           CASE       
           WHEN conflictallow = 'Completed' THEN 2       
                             WHEN conflictallow = 'Reschedule' THEN 2       
        WHEN conflictallow = 'Yes' THEN 10      
                             ELSE conflictallow       
                           END conflictallow,       
                           CASE       
                             WHEN iqallow = 'Completed' THEN 3       
                             WHEN iqallow = 'Reschedule' THEN 3       
        WHEN iqallow = 'Yes' THEN 10      
                             ELSE iqallow       
                           END iqallow,       
                           CASE       
                             WHEN eqallow = 'Completed' THEN 4       
                             WHEN eqallow = 'Reschedule' THEN 4       
        WHEN eqallow = 'Yes' THEN 10      
                             ELSE eqallow       
                           END eqallow ,      
          CASE       
                             WHEN bigfiveallow = 'Completed' THEN 5       
                             WHEN bigfiveallow = 'Reschedule' THEN 5       
        WHEN bigfiveallow = 'Yes' THEN 10      
                             ELSE bigfiveallow       
                           END bigfiveallow,      
         CASE       
        WHEN firoballow = 'Completed' THEN 6       
                             WHEN firoballow = 'Reschedule' THEN 6       
        WHEN firoballow = 'Yes' THEN 10      
                             ELSE firoballow       
                           END firoballow,      
         CASE       
                             WHEN myersbriggsallow = 'Completed' THEN 7       
                             WHEN myersbriggsallow = 'Reschedule' THEN 7       
        WHEN myersbriggsallow = 'Yes' THEN 10      
                             ELSE myersbriggsallow       
                           END myersbriggsallow         
                    FROM   [trecruitcanbasicdtls] a,[vw_apppost] b,[dbo].[trecruitcandidatesignup] c      
      
                    WHERE        
                                 
                             iqallow IN ( 'Completed', 'Reschedule' )       
                                  
       and a.candidateid=c.candidateid      
       and c.username=b.username) a,       
                   [dbo].[trecuitpsycycotesttype] b       
            WHERE  a.iqallow= Cast(b.[id] AS VARCHAR)       
                  AND  (@phytypeid is null or b.id = @phytypeid)    
       and ((replace(replace(REPLACE(@postname, ' ', ''),' ',''),'  ','') )   
 is null or  (replace(replace(REPLACE(a.postname, ' ', ''),' ',''),'  ','') =  
  replace(replace(REPLACE(@postname, ' ', ''),' ',''),'  ','') ))    
                   AND (@deptname is null or a.departmentdivision = @deptname)       
       and (@registrationnumber is null or a.referenceno=@registrationnumber)    
   union      
        SELECT [referenceno],       
                   [candidatename],       
                   [typename]       
            FROM   (SELECT [registrationnumber] [referenceno],       
                     b.[postname],      
          b.[deptname] departmentdivision,      
                           a.[firstname]+' '+a.[middlename]+' '+a.[lastname] [candidatename],       
                           CASE       
                             WHEN discrolallow = 'Completed' THEN 1       
                             WHEN discrolallow = 'Reschedule' THEN 1       
        WHEN discrolallow = 'Yes' THEN 10      
                             ELSE discrolallow       
                           END discrolallow,       
                           CASE       
                             WHEN conflictallow = 'Completed' THEN 2       
                             WHEN conflictallow = 'Reschedule' THEN 2       
        WHEN conflictallow = 'Yes' THEN 10      
                             ELSE conflictallow       
                           END conflictallow,       
                           CASE       
                             WHEN iqallow = 'Completed' THEN 3       
                             WHEN iqallow = 'Reschedule' THEN 3       
        WHEN iqallow = 'Yes' THEN 10      
                             ELSE iqallow       
                           END iqallow,       
                           CASE       
                             WHEN eqallow = 'Completed' THEN 4       
             WHEN eqallow = 'Reschedule' THEN 4       
        WHEN eqallow = 'Yes' THEN 10      
                             ELSE eqallow       
                           END eqallow ,      
          CASE       
                             WHEN bigfiveallow = 'Completed' THEN 5       
                             WHEN bigfiveallow = 'Reschedule' THEN 5       
        WHEN bigfiveallow = 'Yes' THEN 10      
                             ELSE bigfiveallow       
                           END bigfiveallow ,      
         CASE       
                             WHEN firoballow = 'Completed' THEN 6       
                             WHEN firoballow = 'Reschedule' THEN 6       
        WHEN firoballow = 'Yes' THEN 10      
                             ELSE firoballow       
                           END firoballow,      
         CASE       
                             WHEN myersbriggsallow = 'Completed' THEN 7       
                             WHEN myersbriggsallow = 'Reschedule' THEN 7       
        WHEN myersbriggsallow = 'Yes' THEN 10      
                             ELSE myersbriggsallow       
                           END myersbriggsallow        
                    FROM   [trecruitcanbasicdtls] a,[vw_apppost] b,[dbo].[trecruitcandidatesignup] c      
      
                    WHERE        
                                 
                             bigfiveallow IN ( 'Completed', 'Reschedule' )       
                                  
       and a.candidateid=c.candidateid      
       and c.username=b.username) a,       
                   [dbo].[trecuitpsycycotesttype] b       
            WHERE  a.bigfiveallow= Cast(b.[id] AS VARCHAR)       
                   AND  (@phytypeid is null or b.id = @phytypeid)    
        and ((replace(replace(REPLACE(@postname, ' ', ''),' ',''),'  ','') )   
 is null or  (replace(replace(REPLACE(a.postname, ' ', ''),' ',''),'  ','') =  
  replace(replace(REPLACE(@postname, ' ', ''),' ',''),'  ','') ))  
                   AND (@deptname is null or a.departmentdivision = @deptname)       
       and (@registrationnumber is null or a.referenceno=@registrationnumber)    
     union      
        SELECT [referenceno],       
                   [candidatename],       
                   [typename]       
            FROM   (SELECT [registrationnumber] [referenceno],       
                     b.[postname],      
          b.[deptname] departmentdivision,      
                           a.[firstname]+' '+a.[middlename]+' '+a.[lastname] [candidatename],       
                           CASE       
                             WHEN discrolallow = 'Completed' THEN 1       
                             WHEN discrolallow = 'Reschedule' THEN 1       
        WHEN discrolallow = 'Yes' THEN 10      
                             ELSE discrolallow       
                           END discrolallow,       
                           CASE       
                             WHEN conflictallow = 'Completed' THEN 2       
                             WHEN conflictallow = 'Reschedule' THEN 2       
        WHEN conflictallow = 'Yes' THEN 10      
                             ELSE conflictallow       
                           END conflictallow,       
                           CASE       
                             WHEN iqallow = 'Completed' THEN 3       
                             WHEN iqallow = 'Reschedule' THEN 3       
        WHEN iqallow = 'Yes' THEN 10      
                             ELSE iqallow       
                           END iqallow,       
                           CASE       
                             WHEN eqallow = 'Completed' THEN 4       
                             WHEN eqallow = 'Reschedule' THEN 4       
        WHEN eqallow = 'Yes' THEN 10      
                             ELSE eqallow       
                           END eqallow ,      
          CASE       
                             WHEN bigfiveallow = 'Completed' THEN 5       
                             WHEN bigfiveallow = 'Reschedule' THEN 5       
        WHEN bigfiveallow = 'Yes' THEN 10      
                             ELSE bigfiveallow       
                           END bigfiveallow ,      
         CASE       
                             WHEN firoballow = 'Completed' THEN 6       
                             WHEN firoballow = 'Reschedule' THEN 6       
        WHEN firoballow = 'Yes' THEN 10      
                             ELSE firoballow       
                           END firoballow,      
         CASE       
                             WHEN myersbriggsallow = 'Completed' THEN 7       
                             WHEN myersbriggsallow = 'Reschedule' THEN 7       
        WHEN myersbriggsallow = 'Yes' THEN 10      
                             ELSE myersbriggsallow       
                           END myersbriggsallow        
                    FROM   [trecruitcanbasicdtls] a,[vw_apppost] b,[dbo].[trecruitcandidatesignup] c      
      
                    WHERE        
                                 
                             firoballow IN ( 'Completed', 'Reschedule' )       
                                  
       and a.candidateid=c.candidateid      
       and c.username=b.username) a,       
                   [dbo].[trecuitpsycycotesttype] b       
            WHERE  a.firoballow= Cast(b.[id] AS VARCHAR)       
                   AND  (@phytypeid is null or b.id = @phytypeid)    
      and ((replace(replace(REPLACE(@postname, ' ', ''),' ',''),'  ','') )   
 is null or  (replace(replace(REPLACE(a.postname, ' ', ''),' ',''),'  ','') =  
  replace(replace(REPLACE(@postname, ' ', ''),' ',''),'  ','') )) 
                   AND (@deptname is null or a.departmentdivision = @deptname)       
       and (@registrationnumber is null or a.referenceno=@registrationnumber)    
        union      
        SELECT [referenceno],       
                   [candidatename],       
                   [typename]       
            FROM   (SELECT [registrationnumber] [referenceno],       
                     b.[postname],      
          b.[deptname] departmentdivision,      
                           a.[firstname]+' '+a.[middlename]+' '+a.[lastname] [candidatename],       
                           CASE       
                             WHEN discrolallow = 'Completed' THEN 1       
                             WHEN discrolallow = 'Reschedule' THEN 1       
        WHEN discrolallow = 'Yes' THEN 10      
                             ELSE discrolallow       
                           END discrolallow,       
                           CASE       
         WHEN conflictallow = 'Completed' THEN 2       
                             WHEN conflictallow = 'Reschedule' THEN 2       
        WHEN conflictallow = 'Yes' THEN 10      
                             ELSE conflictallow       
                           END conflictallow,       
                           CASE       
                             WHEN iqallow = 'Completed' THEN 3       
                             WHEN iqallow = 'Reschedule' THEN 3       
        WHEN iqallow = 'Yes' THEN 10      
                             ELSE iqallow       
                           END iqallow,       
                           CASE       
                             WHEN eqallow = 'Completed' THEN 4       
                             WHEN eqallow = 'Reschedule' THEN 4       
        WHEN eqallow = 'Yes' THEN 10      
                             ELSE eqallow       
                           END eqallow ,      
          CASE       
                             WHEN bigfiveallow = 'Completed' THEN 5       
                             WHEN bigfiveallow = 'Reschedule' THEN 5       
        WHEN bigfiveallow = 'Yes' THEN 10      
                             ELSE bigfiveallow       
                           END bigfiveallow ,   
         CASE       
                             WHEN firoballow = 'Completed' THEN 6       
                             WHEN firoballow = 'Reschedule' THEN 6       
        WHEN firoballow = 'Yes' THEN 10      
                             ELSE firoballow       
                           END firoballow,      
         CASE       
                             WHEN myersbriggsallow = 'Completed' THEN 7       
                             WHEN myersbriggsallow = 'Reschedule' THEN 7       
        WHEN myersbriggsallow = 'Yes' THEN 10      
                             ELSE myersbriggsallow       
                           END myersbriggsallow        
                    FROM   [trecruitcanbasicdtls] a,[vw_apppost] b,[dbo].[trecruitcandidatesignup] c      
      
                    WHERE        
                                 
                             myersbriggsallow IN ( 'Completed', 'Reschedule' )       
                                  
       and a.candidateid=c.candidateid      
       and c.username=b.username) a,       
                   [dbo].[trecuitpsycycotesttype] b       
            WHERE  a.myersbriggsallow= Cast(b.[id] AS VARCHAR)       
                   AND  (@phytypeid is null or b.id = @phytypeid)    
     and ((replace(replace(REPLACE(@postname, ' ', ''),' ',''),'  ','') )   
 is null or  (replace(replace(REPLACE(a.postname, ' ', ''),' ',''),'  ','') =  
  replace(replace(REPLACE(@postname, ' ', ''),' ',''),'  ','') )) 
                   AND (@deptname is null or a.departmentdivision = @deptname)       
       and (@registrationnumber is null or a.referenceno=@registrationnumber)    
    
       order by referenceno desc    
        END       
      
      IF @action = 'Selecttypewiseotcandidate'       
        BEGIN       
            SELECT [referenceno],       
                   [candidatename],       
                   [typename]       
            FROM   (SELECT             [registrationnumber][referenceno],       
                           a.[firstname]+' '+a.[middlename]+' '+a.[lastname] [candidatename],       
                           CASE       
                             WHEN discrolallow = 'Completed' THEN 1       
                             WHEN discrolallow = 'Reschedule' THEN 1       
        WHEN discrolallow = 'Yes' THEN 10      
                             ELSE discrolallow       
                           END discrolallow,       
                           CASE       
                             WHEN conflictallow = 'Completed' THEN 2       
                             WHEN conflictallow = 'Reschedule' THEN 2       
        WHEN conflictallow = 'Yes' THEN 10      
                             ELSE conflictallow       
                           END conflictallow,       
                           CASE       
                             WHEN iqallow = 'Completed' THEN 3       
                             WHEN iqallow = 'Reschedule' THEN 3       
        WHEN iqallow = 'Yes' THEN 10      
                             ELSE iqallow       
                           END iqallow,       
                           CASE       
                             WHEN eqallow = 'Completed' THEN 4       
                             WHEN eqallow = 'Reschedule' THEN 4       
        WHEN eqallow = 'Yes' THEN 10      
                             ELSE eqallow       
                           END eqallow,      
         CASE       
                             WHEN bigfiveallow = 'Completed' THEN 5       
                             WHEN bigfiveallow = 'Reschedule' THEN 5       
        WHEN bigfiveallow = 'Yes' THEN 10      
                             ELSE bigfiveallow       
                           END bigfiveallow ,      
          CASE       
                             WHEN firoballow = 'Completed' THEN 6       
                             WHEN firoballow = 'Reschedule' THEN 6       
        WHEN firoballow = 'Yes' THEN 10      
                             ELSE firoballow       
                           END firoballow,      
         CASE       
                             WHEN myersbriggsallow = 'Completed' THEN 7       
                             WHEN myersbriggsallow = 'Reschedule' THEN 7       
        WHEN myersbriggsallow = 'Yes' THEN 10      
                             ELSE myersbriggsallow       
                           END myersbriggsallow         
                    FROM   [trecruitcanbasicdtls] a,[trecruitotherpost] b      
                    WHERE   discrolallow IN ( 'Completed', 'Reschedule' )       
                                  
       and a.candidateid=b.candidateid) a,       
                   [dbo].[trecuitpsycycotesttype] b       
            WHERE  a.discrolallow = Cast(b.[id] AS VARCHAR)       
                       
       AND  (@phytypeid is null or b.id = @phytypeid)    
       and (@registrationnumber is null or a.referenceno=@registrationnumber)    
      
       union      
      
       SELECT [referenceno],       
                   [candidatename],       
                   [typename]       
            FROM   (SELECT             [registrationnumber][referenceno],       
                           a.[firstname]+' '+a.[middlename]+' '+a.[lastname] [candidatename],       
                           CASE       
                             WHEN discrolallow = 'Completed' THEN 1       
                             WHEN discrolallow = 'Reschedule' THEN 1       
        WHEN discrolallow = 'Yes' THEN 10      
                             ELSE discrolallow       
                           END discrolallow,       
                           CASE       
                             WHEN conflictallow = 'Completed' THEN 2       
                             WHEN conflictallow = 'Reschedule' THEN 2       
        WHEN conflictallow = 'Yes' THEN 10      
                             ELSE conflictallow       
                           END conflictallow,       
                           CASE       
                             WHEN iqallow = 'Completed' THEN 3       
                             WHEN iqallow = 'Reschedule' THEN 3       
        WHEN iqallow = 'Yes' THEN 10      
                             ELSE iqallow       
                           END iqallow,       
                           CASE       
                             WHEN eqallow = 'Completed' THEN 4       
                             WHEN eqallow = 'Reschedule' THEN 4       
        WHEN eqallow = 'Yes' THEN 10      
                             ELSE eqallow       
                           END eqallow ,      
         CASE       
                             WHEN bigfiveallow = 'Completed' THEN 5       
                             WHEN bigfiveallow = 'Reschedule' THEN 5       
        WHEN bigfiveallow = 'Yes' THEN 10      
                             ELSE bigfiveallow       
                           END bigfiveallow,      
          CASE       
                             WHEN firoballow = 'Completed' THEN 6       
                             WHEN firoballow = 'Reschedule' THEN 6       
        WHEN firoballow = 'Yes' THEN 10      
                             ELSE firoballow       
                           END firoballow,      
         CASE       
                             WHEN myersbriggsallow = 'Completed' THEN 7       
                             WHEN myersbriggsallow = 'Reschedule' THEN 7       
        WHEN myersbriggsallow = 'Yes' THEN 10      
                             ELSE myersbriggsallow       
                           END myersbriggsallow         
                    FROM  [trecruitcanbasicdtls] a,[trecruitotherpost] b      
                    WHERE    conflictallow IN ( 'Completed', 'Reschedule' )       
                                 
       and a.candidateid=b.candidateid) a,       
                   [dbo].[trecuitpsycycotesttype] b       
            WHERE  a.conflictallow = Cast(b.[id] AS VARCHAR)       
                   AND  (@phytypeid is null or b.id = @phytypeid)    
       and (@registrationnumber is null or a.referenceno=@registrationnumber)    
      
       union      
      
       SELECT [referenceno],       
                   [candidatename],       
                   [typename]       
            FROM   (SELECT  [registrationnumber][referenceno],       
                           a.[firstname]+' '+a.[middlename]+' '+a.[lastname] [candidatename],       
                           CASE       
                             WHEN discrolallow = 'Completed' THEN 1       
                             WHEN discrolallow = 'Reschedule' THEN 1       
        WHEN discrolallow = 'Yes' THEN 10      
                             ELSE discrolallow       
                           END discrolallow,       
                           CASE       
                             WHEN conflictallow = 'Completed' THEN 2       
                             WHEN conflictallow = 'Reschedule' THEN 2       
        WHEN conflictallow = 'Yes' THEN 10      
                             ELSE conflictallow       
                           END conflictallow,       
                           CASE       
                             WHEN iqallow = 'Completed' THEN 3       
                             WHEN iqallow = 'Reschedule' THEN 3       
        WHEN iqallow = 'Yes' THEN 10      
                             ELSE iqallow       
                           END iqallow,       
                           CASE       
                             WHEN eqallow = 'Completed' THEN 4       
                             WHEN eqallow = 'Reschedule' THEN 4       
        WHEN eqallow = 'Yes' THEN 10      
                             ELSE eqallow       
                           END eqallow ,      
         CASE       
                             WHEN bigfiveallow = 'Completed' THEN 5       
                             WHEN bigfiveallow = 'Reschedule' THEN 5       
        WHEN bigfiveallow = 'Yes' THEN 10      
                             ELSE bigfiveallow       
                           END bigfiveallow ,      
          CASE       
                             WHEN firoballow = 'Completed' THEN 6       
                             WHEN firoballow = 'Reschedule' THEN 6       
        WHEN firoballow = 'Yes' THEN 10      
                             ELSE firoballow       
                            END firoballow ,      
       CASE       
                             WHEN myersbriggsallow = 'Completed' THEN 7       
                             WHEN myersbriggsallow = 'Reschedule' THEN 7       
        WHEN myersbriggsallow = 'Yes' THEN 10      
                             ELSE myersbriggsallow       
                           END myersbriggsallow       
                    FROM   [trecruitcanbasicdtls] a,[trecruitotherpost] b      
                    WHERE    eqallow IN ( 'Completed', 'Reschedule' )       
                                 
       and a.candidateid=b.candidateid) a,       
                   [dbo].[trecuitpsycycotesttype] b       
            WHERE  a.eqallow = Cast(b.[id] AS VARCHAR)       
                   AND  (@phytypeid is null or b.id = @phytypeid)    
       and (@registrationnumber is null or a.referenceno=@registrationnumber)    
      
       union      
      
       SELECT [referenceno],       
                   [candidatename],       
                   [typename]       
            FROM   (SELECT  [registrationnumber][referenceno],       
                           a.[firstname]+' '+a.[middlename]+' '+a.[lastname] [candidatename],       
                           CASE       
                             WHEN discrolallow = 'Completed' THEN 1       
                             WHEN discrolallow = 'Reschedule' THEN 1       
        WHEN discrolallow = 'Yes' THEN 10      
                             ELSE discrolallow       
                           END discrolallow,       
                           CASE       
                             WHEN conflictallow = 'Completed' THEN 2       
                             WHEN conflictallow = 'Reschedule' THEN 2       
        WHEN conflictallow = 'Yes' THEN 10      
                             ELSE conflictallow       
                           END conflictallow,       
                           CASE       
                             WHEN iqallow = 'Completed' THEN 3       
                             WHEN iqallow = 'Reschedule' THEN 3       
        WHEN iqallow = 'Yes' THEN 10      
                             ELSE iqallow       
                           END iqallow,       
                           CASE       
               WHEN eqallow = 'Completed' THEN 4       
                             WHEN eqallow = 'Reschedule' THEN 4       
        WHEN eqallow = 'Yes' THEN 10      
                             ELSE eqallow       
                           END eqallow ,      
         CASE       
                             WHEN bigfiveallow = 'Completed' THEN 5       
                             WHEN bigfiveallow = 'Reschedule' THEN 5       
        WHEN bigfiveallow = 'Yes' THEN 10      
                             ELSE bigfiveallow       
                           END bigfiveallow ,      
          CASE       
                             WHEN firoballow = 'Completed' THEN 6       
                             WHEN firoballow = 'Reschedule' THEN 6       
        WHEN firoballow = 'Yes' THEN 10      
                             ELSE firoballow       
                           END firoballow,      
         CASE       
                             WHEN myersbriggsallow = 'Completed' THEN 7       
                             WHEN myersbriggsallow = 'Reschedule' THEN 7       
        WHEN myersbriggsallow = 'Yes' THEN 10      
                             ELSE myersbriggsallow       
                           END myersbriggsallow        
                    FROM   [trecruitcanbasicdtls] a,[trecruitotherpost] b      
                    WHERE    iqallow IN ( 'Completed', 'Reschedule' )       
                                 
       and a.candidateid=b.candidateid) a,       
                   [dbo].[trecuitpsycycotesttype] b       
            WHERE  a.iqallow = Cast(b.[id] AS VARCHAR)       
                    AND  (@phytypeid is null or b.id = @phytypeid)    
       and (@registrationnumber is null or a.referenceno=@registrationnumber)    
   union      
      
       SELECT [referenceno],       
                   [candidatename],       
                   [typename]       
            FROM   (SELECT  [registrationnumber][referenceno],       
                           a.[firstname]+' '+a.[middlename]+' '+a.[lastname] [candidatename],       
                           CASE       
                             WHEN discrolallow = 'Completed' THEN 1       
                             WHEN discrolallow = 'Reschedule' THEN 1       
        WHEN discrolallow = 'Yes' THEN 10      
                             ELSE discrolallow       
                           END discrolallow,       
                           CASE       
                             WHEN conflictallow = 'Completed' THEN 2       
                             WHEN conflictallow = 'Reschedule' THEN 2       
        WHEN conflictallow = 'Yes' THEN 10      
                             ELSE conflictallow       
                           END conflictallow,       
                           CASE       
                             WHEN iqallow = 'Completed' THEN 3       
                             WHEN iqallow = 'Reschedule' THEN 3       
        WHEN iqallow = 'Yes' THEN 10      
                             ELSE iqallow       
                           END iqallow,       
                           CASE       
                             WHEN eqallow = 'Completed' THEN 4       
                             WHEN eqallow = 'Reschedule' THEN 4       
        WHEN eqallow = 'Yes' THEN 10      
                             ELSE eqallow       
                           END eqallow ,      
         CASE       
                             WHEN bigfiveallow = 'Completed' THEN 5       
                             WHEN bigfiveallow = 'Reschedule' THEN 5       
        WHEN bigfiveallow = 'Yes' THEN 10      
                             ELSE bigfiveallow       
                           END bigfiveallow ,      
          CASE       
                             WHEN firoballow = 'Completed' THEN 6       
                             WHEN firoballow = 'Reschedule' THEN 6       
        WHEN firoballow = 'Yes' THEN 10      
                             ELSE firoballow       
                           END firoballow,      
         CASE       
                             WHEN myersbriggsallow = 'Completed' THEN 7       
                             WHEN myersbriggsallow = 'Reschedule' THEN 7       
        WHEN myersbriggsallow = 'Yes' THEN 10      
                             ELSE myersbriggsallow       
                           END myersbriggsallow        
                    FROM   [trecruitcanbasicdtls] a,[trecruitotherpost] b      
                    WHERE  bigfiveallow IN ( 'Completed', 'Reschedule' )       
                                 
       and a.candidateid=b.candidateid) a,       
                   [dbo].[trecuitpsycycotesttype] b       
            WHERE  a.bigfiveallow = Cast(b.[id] AS VARCHAR)       
                    AND  (@phytypeid is null or b.id = @phytypeid)    
       and (@registrationnumber is null or a.referenceno=@registrationnumber)    
        union      
      
       SELECT [referenceno],       
                   [candidatename],       
                   [typename]       
            FROM   (SELECT  [registrationnumber][referenceno],       
                           a.[firstname]+' '+a.[middlename]+' '+a.[lastname] [candidatename],       
                           CASE       
                             WHEN discrolallow = 'Completed' THEN 1       
                    WHEN discrolallow = 'Reschedule' THEN 1       
        WHEN discrolallow = 'Yes' THEN 10      
                             ELSE discrolallow       
                           END discrolallow,       
                           CASE       
                             WHEN conflictallow = 'Completed' THEN 2       
                             WHEN conflictallow = 'Reschedule' THEN 2       
        WHEN conflictallow = 'Yes' THEN 10      
                             ELSE conflictallow       
                           END conflictallow,       
                           CASE       
                             WHEN iqallow = 'Completed' THEN 3       
                             WHEN iqallow = 'Reschedule' THEN 3       
        WHEN iqallow = 'Yes' THEN 10      
                             ELSE iqallow       
                           END iqallow,       
                           CASE       
                             WHEN eqallow = 'Completed' THEN 4       
                             WHEN eqallow = 'Reschedule' THEN 4       
        WHEN eqallow = 'Yes' THEN 10      
                             ELSE eqallow       
                           END eqallow ,      
         CASE       
                             WHEN bigfiveallow = 'Completed' THEN 5       
                             WHEN bigfiveallow = 'Reschedule' THEN 5       
        WHEN bigfiveallow = 'Yes' THEN 10      
                             ELSE bigfiveallow       
                           END bigfiveallow ,      
          CASE       
                             WHEN firoballow = 'Completed' THEN 6       
                             WHEN firoballow = 'Reschedule' THEN 6       
        WHEN firoballow = 'Yes' THEN 10      
                             ELSE firoballow       
                           END firoballow,      
         CASE       
                             WHEN myersbriggsallow = 'Completed' THEN 7       
                             WHEN myersbriggsallow = 'Reschedule' THEN 7       
        WHEN myersbriggsallow = 'Yes' THEN 10      
                             ELSE myersbriggsallow       
                           END myersbriggsallow        
                    FROM   [trecruitcanbasicdtls] a,[trecruitotherpost] b      
                    WHERE    firoballow IN ( 'Completed', 'Reschedule' )       
                                 
       and a.candidateid=b.candidateid) a,       
                   [dbo].[trecuitpsycycotesttype] b       
            WHERE  a.firoballow = Cast(b.[id] AS VARCHAR)       
                    AND  (@phytypeid is null or b.id = @phytypeid)    
       and (@registrationnumber is null or a.referenceno=@registrationnumber)    
           union      
      
       SELECT [referenceno],       
                   [candidatename],       
                   [typename]       
            FROM   (SELECT  [registrationnumber][referenceno],       
                           a.[firstname]+' '+a.[middlename]+' '+a.[lastname] [candidatename],       
                           CASE       
                             WHEN discrolallow = 'Completed' THEN 1       
                             WHEN discrolallow = 'Reschedule' THEN 1       
        WHEN discrolallow = 'Yes' THEN 10      
                             ELSE discrolallow       
                           END discrolallow,       
                           CASE       
                             WHEN conflictallow = 'Completed' THEN 2       
                             WHEN conflictallow = 'Reschedule' THEN 2       
        WHEN conflictallow = 'Yes' THEN 10      
                             ELSE conflictallow       
                           END conflictallow,       
                           CASE       
                            WHEN iqallow = 'Completed' THEN 3       
                             WHEN iqallow = 'Reschedule' THEN 3       
        WHEN iqallow = 'Yes' THEN 10      
                             ELSE iqallow       
                           END iqallow,       
                           CASE       
                             WHEN eqallow = 'Completed' THEN 4       
                             WHEN eqallow = 'Reschedule' THEN 4       
     WHEN eqallow = 'Yes' THEN 10      
                             ELSE eqallow       
                           END eqallow ,      
         CASE       
                             WHEN bigfiveallow = 'Completed' THEN 5       
                             WHEN bigfiveallow = 'Reschedule' THEN 5       
        WHEN bigfiveallow = 'Yes' THEN 10      
                             ELSE bigfiveallow       
                           END bigfiveallow ,      
          CASE       
                             WHEN firoballow = 'Completed' THEN 6       
                             WHEN firoballow = 'Reschedule' THEN 6       
        WHEN firoballow = 'Yes' THEN 10      
                             ELSE firoballow       
                           END firoballow,      
         CASE       
                             WHEN myersbriggsallow = 'Completed' THEN 7       
                             WHEN myersbriggsallow = 'Reschedule' THEN 7       
        WHEN myersbriggsallow = 'Yes' THEN 10      
                             ELSE myersbriggsallow       
                           END myersbriggsallow        
                    FROM   [trecruitcanbasicdtls] a,[trecruitotherpost] b      
                    WHERE    myersbriggsallow IN ( 'Completed', 'Reschedule' )       
                                 
       and a.candidateid=b.candidateid) a,       
                   [dbo].[trecuitpsycycotesttype] b       
            WHERE  a.myersbriggsallow = Cast(b.[id] AS VARCHAR)       
                    AND  (@phytypeid is null or b.id = @phytypeid)    
       and (@registrationnumber is null or a.referenceno=@registrationnumber)    
    
       order by referenceno desc    
        END       
      
      IF @action = 'Selectquesans'       
        BEGIN       
            SELECT [disquestype],       
                   [quesserialno],       
                   [question],       
                   f.[answer]       
            FROM   [trecruitdiscrolcandidatedtls] a,       
                   [dbo].[trecruitdiscrolqusdtls] b,       
                   [dbo].[trecruitdiscrolquestype] c,       
                   [dbo].[trecruitdiscrolansdtls]f,       
                   [dbo].[trecruitcanbasicdtls] d,       
                   [dbo].[languages]e       
            WHERE  a.[languageid] = b.[languageid]       
                   AND a.[questionid] = b.[quesserialno]       
                   AND b.[disquestypeid] = c.[id]       
                   AND a.[candidateid] = d.[candidateid]       
                   AND a.[languageid] = e.[id]       
                   AND a.answer = f.number       
                   AND a.[languageid] = f.[languageid]       
                   AND a.candidateid = @candidateid       
                   AND [candidateattemexam] = @candidateattemexam       
            ORDER  BY [quesserialno]       
        END       
      
      IF @action = 'Reschedule'       
        BEGIN       
            --SELECT @candiscrolallow = [discrolallow]       
            --FROM   [Recruitment].[dbo].[trecruittraker]       
            --WHERE  [candidateid] = @candidateid       
            --GROUP  BY [discrolallow],       
            --          [conflictallow],       
            --          [iqallow],       
            --          [eqallow]       
      
   SELECT @candiscrolallow = [discrolallow]       
            FROM   [dbo].[trecruitcanbasicdtls]      
            WHERE  [candidateid] = @candidateid       
            GROUP  BY [discrolallow],       
                      [conflictallow],       
                      [iqallow],       
                      [eqallow]       
      
                   
            IF @candiscrolallow = 'Completed'       
              BEGIN       
                  UPDATE [trecruitcanbasicdtls]       
                  SET    [discrolallow] = 'Reschedule'       
                  WHERE  [candidateid] = @candidateid       
              END       
            ELSE       
              BEGIN       
                  SET @message=1       
              END       
        END       
      
      IF @action = 'SELECTEXAMNO'       
    BEGIN       
            SELECT [attemexam],       
                   CASE       
                     WHEN [attemexam] = 1 THEN Cast('1st Exam' AS VARCHAR)       
                     WHEN [attemexam] = 2 THEN Cast('2nd Exam'AS VARCHAR)       
                     WHEN [attemexam] = 3 THEN Cast('3rd Exam'AS VARCHAR)       
                     ELSE Cast([attemexam]AS VARCHAR) + '' + 'th Exam'       
                   END [attemexamtext]       
            FROM   [trecruitdiscrolexamdtls]       
            WHERE  candidateid = @candidateid       
                   AND finalsubmit = 'Yes'       
            ORDER  BY [attemexam]       
        END       
      
      IF @action = 'Selecttypewisetotalno'       
        BEGIN       
            SELECT c.[disquestype],       
                   a.questionid,       
                   a.answer,       
                   totscore       
            FROM   [trecruitdiscrolcandidatedtls] a,       
                   [dbo].[trecruitdiscrolqusdtls] b,       
                   [dbo].[trecruitdiscrolquestype] c,       
                   [dbo].[trecruitdiscrolansdtls]f,       
                   [dbo].[trecruitcanbasicdtls] d,       
                   [dbo].[languages]e,       
                   (SELECT c.[disquestype],       
                           Sum (a.answer)totscore       
                    FROM   [trecruitdiscrolcandidatedtls] a,       
                           [dbo].[trecruitdiscrolqusdtls] b,       
                           [dbo].[trecruitdiscrolquestype] c,       
                           [dbo].[trecruitdiscrolansdtls]f,       
                           [dbo].[trecruitcanbasicdtls] d,       
                           [dbo].[languages]e       
                    WHERE  a.[languageid] = b.[languageid]       
                           AND a.[questionid] = b.[quesserialno]       
                           AND b.[disquestypeid] = c.[id]       
                           AND a.[candidateid] = d.[candidateid]       
                           AND a.[languageid] = e.[id]       
                            AND a.answer = f.[number]      
         and a.[languageid]=f.[languageid]         
                           AND a.candidateid = @candidateid       
                           AND [candidateattemexam] = @candidateattemexam       
                    GROUP  BY c.[disquestype]) z       
            WHERE  a.[languageid] = b.[languageid]       
                   AND a.[questionid] = b.[quesserialno]       
                   AND b.[disquestypeid] = c.[id]       
                   AND a.[candidateid] = d.[candidateid]       
                   AND a.[languageid] = e.[id]       
                    AND a.answer = f.[number]      
     and a.[languageid]=f.[languageid]         
                   AND a.candidateid = @candidateid       
                   AND [candidateattemexam] = @candidateattemexam       
                   AND c.[disquestype] = z.[disquestype]       
            ORDER  BY [disquestype]       
        END       
      
      IF @action = 'Discrolgraph'       
        BEGIN       
            SELECT ( d.totscore * 1.363636 ) TIGERfinalscore,       
                   ( a.totscore * 2 )        CHAMELEONfinalscore,       
                   ( e.totscore * 2.1428 )   TURTLEfinalscore,       
                   ( b.totscore * 1.363636 ) EAGLEfinalscore,       
                   ( a.totscore * 2 )        SALMONfinalscore       
            FROM   (SELECT c.[disquestype],       
                           a.candidateid,       
                           Sum (a.answer)totscore       
                    FROM  [trecruitdiscrolcandidatedtls] a,       
                           [dbo].[trecruitdiscrolqusdtls] b,       
                           [dbo].[trecruitdiscrolquestype] c,       
                           [dbo].[trecruitdiscrolansdtls]f,       
                           [dbo].[trecruitcanbasicdtls] d,       
                           [dbo].[languages]e       
                    WHERE  a.[languageid] = b.[languageid]       
                           AND a.[questionid] = b.[quesserialno]       
                           AND b.[disquestypeid] = c.[id]       
                           AND a.[candidateid] = d.[candidateid]       
                           AND a.[languageid] = e.[id]       
                            AND a.answer = f.[number]      
         and a.[languageid]=f.[languageid]          
                           AND a.candidateid = @candidateid       
                           AND [candidateattemexam] = @candidateattemexam       
                           AND c.[disquestype] = 'CHAMELEON'       
                    GROUP  BY c.[disquestype],       
                              a.candidateid) a,       
                   (SELECT c.[disquestype],       
                           a.candidateid,       
                           Sum (a.answer)totscore       
                    FROM   [trecruitdiscrolcandidatedtls] a,       
                           [dbo].[trecruitdiscrolqusdtls] b,       
                           [dbo].[trecruitdiscrolquestype] c,       
                           [dbo].[trecruitdiscrolansdtls]f,       
                           [dbo].[trecruitcanbasicdtls] d,       
                           [dbo].[languages]e       
                    WHERE  a.[languageid] = b.[languageid]       
                           AND a.[questionid] = b.[quesserialno]       
                           AND b.[disquestypeid] = c.[id]       
                           AND a.[candidateid] = d.[candidateid]       
                           AND a.[languageid] = e.[id]       
                            AND a.answer = f.[number]      
         and a.[languageid]=f.[languageid]         
                           AND a.candidateid = @candidateid       
                           AND [candidateattemexam] = @candidateattemexam       
                           AND c.[disquestype] = 'EAGLE'       
                    GROUP  BY c.[disquestype],       
                              a.candidateid) b,       
                   (SELECT c.[disquestype],       
                           a.candidateid,       
                           Sum (a.answer)totscore       
                    FROM   [trecruitdiscrolcandidatedtls] a,       
                           [dbo].[trecruitdiscrolqusdtls] b,       
                           [dbo].[trecruitdiscrolquestype] c,       
                           [dbo].[trecruitdiscrolansdtls]f,       
                           [dbo].[trecruitcanbasicdtls] d,       
                           [dbo].[languages]e       
                    WHERE  a.[languageid] = b.[languageid]       
                           AND a.[questionid] = b.[quesserialno]       
                           AND b.[disquestypeid] = c.[id]       
                           AND a.[candidateid] = d.[candidateid]       
                           AND a.[languageid] = e.[id]       
                            AND a.answer = f.[number]      
         and a.[languageid]=f.[languageid]         
                           AND a.candidateid = @candidateid       
                           AND [candidateattemexam] = @candidateattemexam       
                           AND c.[disquestype] = 'SALMON'       
                    GROUP  BY c.[disquestype],       
                              a.candidateid) c,       
                   (SELECT c.[disquestype],       
                           a.candidateid,       
                           Sum (a.answer)totscore       
                    FROM   [trecruitdiscrolcandidatedtls] a,       
                           [dbo].[trecruitdiscrolqusdtls] b,       
                           [dbo].[trecruitdiscrolquestype] c,       
                           [dbo].[trecruitdiscrolansdtls]f,       
                           [dbo].[trecruitcanbasicdtls] d,       
                           [dbo].[languages]e       
                    WHERE  a.[languageid] = b.[languageid]       
                           AND a.[questionid] = b.[quesserialno]       
                           AND b.[disquestypeid] = c.[id]       
                           AND a.[candidateid] = d.[candidateid]       
                           AND a.[languageid] = e.[id]       
                            AND a.answer = f.[number]      
         and a.[languageid]=f.[languageid]         
                           AND a.candidateid = @candidateid       
                           AND [candidateattemexam] = @candidateattemexam       
                           AND c.[disquestype] = 'TIGER'       
                    GROUP  BY c.[disquestype],       
                              a.candidateid) d,       
                   (SELECT c.[disquestype],       
                           a.candidateid,       
                           Sum (a.answer)totscore       
                    FROM   [trecruitdiscrolcandidatedtls] a,       
                           [dbo].[trecruitdiscrolqusdtls] b,       
                           [dbo].[trecruitdiscrolquestype] c,       
                           [dbo].[trecruitdiscrolansdtls]f,       
                           [dbo].[trecruitcanbasicdtls] d,       
                           [dbo].[languages]e       
                    WHERE  a.[languageid] = b.[languageid]       
                           AND a.[questionid] = b.[quesserialno]       
                           AND b.[disquestypeid] = c.[id]       
                           AND a.[candidateid] = d.[candidateid]       
                           AND a.[languageid] = e.[id]       
                            AND a.answer = f.[number]      
         and a.[languageid]=f.[languageid]         
                           AND a.candidateid = @candidateid       
                           AND [candidateattemexam] = @candidateattemexam       
                           AND c.[disquestype] = 'TURTLE'       
                    GROUP  BY c.[disquestype],       
                              a.candidateid) e       
            WHERE  a.candidateid = b.candidateid       
                   AND a.candidateid = c.candidateid       
                   AND a.candidateid = d.candidateid       
                   AND a.candidateid = e.candidateid       
        END       
      
      IF @action = 'Activeinactiveresbutton'       
        BEGIN       
            SELECT       
                   a.[discrolallow]       
            FROM   [dbo].[trecruitcanbasicdtls] a                      
            WHERE a.candidateid = @candidateid       
        END       
  END 
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: Languages, trecruitcanbasicdtls, trecruitcandidatesignup, trecruitdiscrolansdtls, trecruitdiscrolcandidatedtls, trecruitdiscrolexamdtls, trecruitdiscrolquestype, trecruitdiscrolqusdtls, trecruitotherpost, trecruitpostlocationmap, trecruittraker, trecuitpsycycotesttype */
/****** Object:  StoredProcedure [dbo].[procdishrdtlsforconfidential]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
            
/****** Script for SelectTopNRows command from SSMS  ******/             
CREATE PROC [dbo].[procdishrdtlsforconfidential] @action         VARCHAR(100)=NULL,             
                                 @phytypeid          INT=NULL,             
                                 @postname           VARCHAR(500)=NULL,             
                                 @deptname           VARCHAR(500)=NULL,             
                                 @candidateattemexam INT=NULL,             
                                 @registrationnumber VARCHAR(200)=NULL,             
                                 @discrolallow       VARCHAR(200)=NULL,             
                                 @Message            VARCHAR(200)=NULL             
AS             
    DECLARE @candidateid INT             
    DECLARE @candiscrolallow VARCHAR(200)             
            
  BEGIN           
  if(@phytypeid is null or @phytypeid=0)          
  begin          
  set          
  @phytypeid=null          
  end          
  if(@postname is null or @postname='0')          
  begin          
  set          
  @postname=null          
  end          
  if(@registrationnumber is null or @registrationnumber='0')          
  begin          
  set          
  @registrationnumber=null          
  end          
      SELECT @candidateid = candidateid             
      FROM   [dbo].[trecruitcanbasicdtls]             
      WHERE  registrationnumber = @registrationnumber             
            
              
            
            
      IF @action = 'Selecttypewisecandidate'             
        BEGIN             
                      
            
        SELECT Distinct [referenceno],             
                           [candidatename],             
                           [typename]             
            FROM   (SELECT [registrationnumber] [referenceno],             
                     b.[postname],            
          b.[deptname] departmentdivision, d.Confidentialpost,           
                          dbo.Candidate_FullName(a.[firstname],a.[middlename],a.[lastname]) [candidatename],             
                           CASE             
                             WHEN discrolallow = 'Completed' THEN 1             
                             WHEN discrolallow = 'Reschedule' THEN 1             
        WHEN discrolallow = 'Yes' THEN 10            
                             ELSE discrolallow             
                           END discrolallow,             
                           CASE             
                             WHEN conflictallow = 'Completed' THEN 2             
                             WHEN conflictallow = 'Reschedule' THEN 2             
        WHEN conflictallow = 'Yes' THEN 10            
                             ELSE conflictallow             
                           END conflictallow,             
                           CASE             
                             WHEN iqallow = 'Completed' THEN 3             
                             WHEN iqallow = 'Reschedule' THEN 3             
        WHEN iqallow = 'Yes' THEN 10            
                             ELSE iqallow             
                           END iqallow,             
                           CASE             
                             WHEN eqallow = 'Completed' THEN 4             
                             WHEN eqallow = 'Reschedule' THEN 4             
        WHEN eqallow = 'Yes' THEN 10            
                             ELSE eqallow             
                           END eqallow ,            
         CASE             
                             WHEN bigfiveallow = 'Completed' THEN 5             
                             WHEN bigfiveallow = 'Reschedule' THEN 5             
        WHEN bigfiveallow = 'Yes' THEN 10            
                             ELSE bigfiveallow            
        end bigfiveallow,            
        CASE             
                             WHEN firoballow = 'Completed' THEN 6             
                   WHEN firoballow = 'Reschedule' THEN 6             
        WHEN firoballow = 'Yes' THEN 10            
                             ELSE firoballow             
        END firoballow,             
        CASE             
                             WHEN myersbriggsallow = 'Completed' THEN 7             
                             WHEN myersbriggsallow = 'Reschedule' THEN 7             
        WHEN myersbriggsallow = 'Yes' THEN 10            
                             ELSE myersbriggsallow             
                           END myersbriggsallow             
                    FROM   [trecruitcanbasicdtls] a,[vw_apppost] b,[dbo].[trecruitcandidatesignup] c    
     ,[dbo].[trecruitpostlocationmap] d  
            
                    WHERE              
       discrolallow IN ( 'Completed', 'Reschedule' )             
                                        
       and a.candidateid=c.candidateid            
       and c.username=b.username  
    and b.postid=d.postid and b.locid=d.locid) a,             
                   [dbo].[trecuitpsycycotesttype] b             
            WHERE  a.discrolallow = Cast(b.[id] AS VARCHAR)             
                   AND  (@phytypeid is null or b.id = @phytypeid)          
       and (@postname is null or a.postname = @postname )            
                   AND (@deptname is null or a.departmentdivision = @deptname)     
       and a.Confidentialpost='1'  
               
                 
                
       union            
        SELECT Distinct [referenceno],             
                   [candidatename],             
                   [typename]             
            FROM   (SELECT [registrationnumber] [referenceno],             
                     b.[postname],            
          b.[deptname] departmentdivision, d.Confidentialpost,           
                           dbo.Candidate_FullName(a.[firstname],a.[middlename],a.[lastname]) [candidatename],             
                           CASE             
                             WHEN discrolallow = 'Completed' THEN 1             
                             WHEN discrolallow = 'Reschedule' THEN 1             
        WHEN discrolallow = 'Yes' THEN 10            
                             ELSE discrolallow             
                           END discrolallow,             
                           CASE             
                             WHEN conflictallow = 'Completed' THEN 2             
                             WHEN conflictallow = 'Reschedule' THEN 2             
        WHEN conflictallow = 'Yes' THEN 10            
                             ELSE conflictallow             
                           END conflictallow,             
                           CASE             
                             WHEN iqallow = 'Completed' THEN 3             
                             WHEN iqallow = 'Reschedule' THEN 3             
        WHEN iqallow = 'Yes' THEN 10            
                             ELSE iqallow             
                           END iqallow,             
                           CASE             
                             WHEN eqallow = 'Completed' THEN 4             
                             WHEN eqallow = 'Reschedule' THEN 4             
        WHEN eqallow = 'Yes' THEN 10            
                             ELSE eqallow             
                           END eqallow ,            
          CASE             
                             WHEN bigfiveallow = 'Completed' THEN 5             
                             WHEN bigfiveallow = 'Reschedule' THEN 5             
        WHEN bigfiveallow = 'Yes' THEN 10            
                             ELSE bigfiveallow             
                           END bigfiveallow,            
         CASE             
                             WHEN firoballow = 'Completed' THEN 6             
                             WHEN firoballow = 'Reschedule' THEN 6             
        WHEN firoballow = 'Yes' THEN 10   
                             ELSE firoballow             
                           END firoballow,            
         CASE             
                             WHEN myersbriggsallow = 'Completed' THEN 7             
                             WHEN myersbriggsallow = 'Reschedule' THEN 7             
        WHEN myersbriggsallow = 'Yes' THEN 10            
                             ELSE myersbriggsallow             
         END myersbriggsallow               
                    FROM   [trecruitcanbasicdtls] a,[vw_apppost] b,[dbo].[trecruitcandidatesignup] c            
                          ,[dbo].[trecruitpostlocationmap] d  
                    WHERE              
                                       
                             conflictallow IN ( 'Completed', 'Reschedule' )        
                                        
       and a.candidateid=c.candidateid            
       and c.username=b.username  
     and b.postid=d.postid and b.locid=d.locid) a,             
                   [dbo].[trecuitpsycycotesttype] b             
            WHERE  a.conflictallow= Cast(b.[id] AS VARCHAR)             
                    AND  (@phytypeid is null or b.id = @phytypeid)          
       and (@postname is null or a.postname = @postname )            
                   AND (@deptname is null or a.departmentdivision = @deptname)       
         and a.Confidentialpost='1'  
       union            
        SELECT distinct [referenceno],             
                   [candidatename],             
                   [typename]             
            FROM   (SELECT [registrationnumber] [referenceno],             
                   b.[postname],            
          b.[deptname] departmentdivision, d.Confidentialpost,            
                           dbo.Candidate_FullName(a.[firstname],a.[middlename],a.[lastname]) [candidatename],            
                           CASE             
                             WHEN discrolallow = 'Completed' THEN 1             
                             WHEN discrolallow = 'Reschedule' THEN 1             
        WHEN discrolallow = 'Yes' THEN 10            
                             ELSE discrolallow             
                           END discrolallow,             
                           CASE             
                             WHEN conflictallow = 'Completed' THEN 2             
                             WHEN conflictallow = 'Reschedule' THEN 2             
        WHEN conflictallow = 'Yes' THEN 10            
                             ELSE conflictallow             
           END conflictallow,             
                           CASE             
                             WHEN iqallow = 'Completed' THEN 3             
                             WHEN iqallow = 'Reschedule' THEN 3             
        WHEN iqallow = 'Yes' THEN 10            
                             ELSE iqallow             
                           END iqallow,             
                           CASE             
                             WHEN eqallow = 'Completed' THEN 4             
                             WHEN eqallow = 'Reschedule' THEN 4             
        WHEN eqallow = 'Yes' THEN 10            
                             ELSE eqallow             
                           END eqallow ,            
          CASE             
                             WHEN bigfiveallow = 'Completed' THEN 5             
                             WHEN bigfiveallow = 'Reschedule' THEN 5             
        WHEN bigfiveallow = 'Yes' THEN 10            
                             ELSE bigfiveallow             
                           END bigfiveallow,            
         CASE             
                             WHEN firoballow = 'Completed' THEN 6             
                             WHEN firoballow = 'Reschedule' THEN 6             
        WHEN firoballow = 'Yes' THEN 10            
                             ELSE firoballow             
                           END firoballow,            
         CASE             
                             WHEN myersbriggsallow = 'Completed' THEN 7             
                             WHEN myersbriggsallow = 'Reschedule' THEN 7             
        WHEN myersbriggsallow = 'Yes' THEN 10            
                             ELSE myersbriggsallow             
                           END myersbriggsallow               
                    FROM   [trecruitcanbasicdtls] a,[vw_apppost] b,[dbo].[trecruitcandidatesignup] c            
                           ,[dbo].[trecruitpostlocationmap] d  
                    WHERE              
                                       
                             eqallow IN ( 'Completed', 'Reschedule' )             
                                        
  and a.candidateid=c.candidateid            
       and c.username=b.username  
     and b.postid=d.postid and b.locid=d.locid) a,             
                   [dbo].[trecuitpsycycotesttype] b             
            WHERE  a.eqallow= Cast(b.[id] AS VARCHAR)             
                   AND  (@phytypeid is null or b.id = @phytypeid)          
       and (@postname is null or a.postname = @postname )            
                   AND (@deptname is null or a.departmentdivision = @deptname)   
       and a.Confidentialpost='1'  
            
   union            
        SELECT Distinct [referenceno],             
                   [candidatename],             
                   [typename]             
            FROM   (SELECT [registrationnumber] [referenceno],             
                     b.[postname],            
          b.[deptname] departmentdivision, d.Confidentialpost,           
                           dbo.Candidate_FullName(a.[firstname],a.[middlename],a.[lastname]) [candidatename],             
                           CASE             
                             WHEN discrolallow = 'Completed' THEN 1             
                        WHEN discrolallow = 'Reschedule' THEN 1             
        WHEN discrolallow = 'Yes' THEN 10            
                             ELSE discrolallow             
                           END discrolallow,             
                           CASE             
                             WHEN conflictallow = 'Completed' THEN 2             
                             WHEN conflictallow = 'Reschedule' THEN 2             
        WHEN conflictallow = 'Yes' THEN 10            
          ELSE conflictallow             
                           END conflictallow,             
                           CASE             
                             WHEN iqallow = 'Completed' THEN 3             
                             WHEN iqallow = 'Reschedule' THEN 3             
        WHEN iqallow = 'Yes' THEN 10            
                             ELSE iqallow             
                           END iqallow,             
                           CASE             
                             WHEN eqallow = 'Completed' THEN 4             
                             WHEN eqallow = 'Reschedule' THEN 4             
        WHEN eqallow = 'Yes' THEN 10            
                             ELSE eqallow             
                           END eqallow ,            
          CASE             
                             WHEN bigfiveallow = 'Completed' THEN 5             
                             WHEN bigfiveallow = 'Reschedule' THEN 5             
        WHEN bigfiveallow = 'Yes' THEN 10            
                             ELSE bigfiveallow             
                           END bigfiveallow,            
         CASE             
        WHEN firoballow = 'Completed' THEN 6             
                             WHEN firoballow = 'Reschedule' THEN 6             
        WHEN firoballow = 'Yes' THEN 10            
                             ELSE firoballow             
                           END firoballow,            
         CASE             
                             WHEN myersbriggsallow = 'Completed' THEN 7   
                             WHEN myersbriggsallow = 'Reschedule' THEN 7             
        WHEN myersbriggsallow = 'Yes' THEN 10            
                             ELSE myersbriggsallow             
                           END myersbriggsallow               
                    FROM   [trecruitcanbasicdtls] a,[vw_apppost] b,[dbo].[trecruitcandidatesignup] c            
                            ,[dbo].[trecruitpostlocationmap] d  
                    WHERE              
                                       
                             iqallow IN ( 'Completed', 'Reschedule' )             
                                        
       and a.candidateid=c.candidateid            
       and c.username=b.username  
     and b.postid=d.postid and b.locid=d.locid) a,             
                   [dbo].[trecuitpsycycotesttype] b             
            WHERE  a.iqallow= Cast(b.[id] AS VARCHAR)             
                    AND  (@phytypeid is null or b.id = @phytypeid)          
       and (@postname is null or a.postname = @postname )            
                   AND (@deptname is null or a.departmentdivision = @deptname)    
        and a.Confidentialpost='1'  
   union            
        SELECT Distinct [referenceno],             
                   [candidatename],             
                   [typename]             
            FROM   (SELECT [registrationnumber] [referenceno],             
                     b.[postname],            
          b.[deptname] departmentdivision, d.Confidentialpost,            
                           dbo.Candidate_FullName(a.[firstname],a.[middlename],a.[lastname]) [candidatename],            
                           CASE             
                             WHEN discrolallow = 'Completed' THEN 1             
                             WHEN discrolallow = 'Reschedule' THEN 1             
        WHEN discrolallow = 'Yes' THEN 10            
                             ELSE discrolallow             
                           END discrolallow,             
                           CASE             
                             WHEN conflictallow = 'Completed' THEN 2             
                             WHEN conflictallow = 'Reschedule' THEN 2             
        WHEN conflictallow = 'Yes' THEN 10            
                             ELSE conflictallow             
                           END conflictallow,             
                           CASE             
                             WHEN iqallow = 'Completed' THEN 3             
                             WHEN iqallow = 'Reschedule' THEN 3             
        WHEN iqallow = 'Yes' THEN 10            
                             ELSE iqallow             
                           END iqallow,             
                           CASE             
                             WHEN eqallow = 'Completed' THEN 4             
                             WHEN eqallow = 'Reschedule' THEN 4             
        WHEN eqallow = 'Yes' THEN 10            
                             ELSE eqallow             
                           END eqallow ,            
          CASE             
                             WHEN bigfiveallow = 'Completed' THEN 5             
                             WHEN bigfiveallow = 'Reschedule' THEN 5             
        WHEN bigfiveallow = 'Yes' THEN 10            
                             ELSE bigfiveallow             
                           END bigfiveallow ,            
         CASE             
                             WHEN firoballow = 'Completed' THEN 6             
                             WHEN firoballow = 'Reschedule' THEN 6             
        WHEN firoballow = 'Yes' THEN 10            
                             ELSE firoballow             
                           END firoballow,            
         CASE             
                             WHEN myersbriggsallow = 'Completed' THEN 7             
                             WHEN myersbriggsallow = 'Reschedule' THEN 7           
        WHEN myersbriggsallow = 'Yes' THEN 10            
                             ELSE myersbriggsallow             
                           END myersbriggsallow              
                    FROM   [trecruitcanbasicdtls] a,[vw_apppost] b,[dbo].[trecruitcandidatesignup] c            
                           ,[dbo].[trecruitpostlocationmap] d  
                    WHERE              
                                       
                             bigfiveallow IN ( 'Completed', 'Reschedule' )             
                                        
       and a.candidateid=c.candidateid            
       and c.username=b.username  
    and b.postid=d.postid and b.locid=d.locid) a,             
                   [dbo].[trecuitpsycycotesttype] b             
            WHERE  a.bigfiveallow= Cast(b.[id] AS VARCHAR)             
                   AND  (@phytypeid is null or b.id = @phytypeid)          
       and (@postname is null or a.postname = @postname )            
                   AND (@deptname is null or a.departmentdivision = @deptname)   
        and a.Confidentialpost='1'  
     union            
        SELECT Distinct [referenceno],             
                   [candidatename],             
                   [typename]             
            FROM   (SELECT [registrationnumber] [referenceno],             
                     b.[postname],            
          b.[deptname] departmentdivision,  d.Confidentialpost,          
                           dbo.Candidate_FullName(a.[firstname],a.[middlename],a.[lastname]) [candidatename],           
                           CASE             
                             WHEN discrolallow = 'Completed' THEN 1             
                             WHEN discrolallow = 'Reschedule' THEN 1             
        WHEN discrolallow = 'Yes' THEN 10            
                             ELSE discrolallow             
                           END discrolallow,             
                           CASE             
                             WHEN conflictallow = 'Completed' THEN 2             
                             WHEN conflictallow = 'Reschedule' THEN 2             
        WHEN conflictallow = 'Yes' THEN 10            
                             ELSE conflictallow             
                           END conflictallow,             
                           CASE             
                             WHEN iqallow = 'Completed' THEN 3             
                             WHEN iqallow = 'Reschedule' THEN 3             
        WHEN iqallow = 'Yes' THEN 10            
                             ELSE iqallow             
                           END iqallow,             
                           CASE             
                             WHEN eqallow = 'Completed' THEN 4             
                             WHEN eqallow = 'Reschedule' THEN 4             
        WHEN eqallow = 'Yes' THEN 10            
                             ELSE eqallow             
                           END eqallow ,            
          CASE             
                             WHEN bigfiveallow = 'Completed' THEN 5             
                             WHEN bigfiveallow = 'Reschedule' THEN 5             
        WHEN bigfiveallow = 'Yes' THEN 10            
                             ELSE bigfiveallow             
                           END bigfiveallow ,            
         CASE             
                             WHEN firoballow = 'Completed' THEN 6             
                             WHEN firoballow = 'Reschedule' THEN 6             
        WHEN firoballow = 'Yes' THEN 10            
                             ELSE firoballow             
                           END firoballow,            
         CASE             
                             WHEN myersbriggsallow = 'Completed' THEN 7             
                             WHEN myersbriggsallow = 'Reschedule' THEN 7             
        WHEN myersbriggsallow = 'Yes' THEN 10            
                        ELSE myersbriggsallow             
                           END myersbriggsallow              
                    FROM   [trecruitcanbasicdtls] a,[vw_apppost] b,[dbo].[trecruitcandidatesignup] c            
                           ,[dbo].[trecruitpostlocationmap] d  
                    WHERE              
                                       
                             firoballow IN ( 'Completed', 'Reschedule' )             
                                        
       and a.candidateid=c.candidateid            
       and c.username=b.username  
      and b.postid=d.postid and b.locid=d.locid) a,             
                   [dbo].[trecuitpsycycotesttype] b             
            WHERE  a.firoballow= Cast(b.[id] AS VARCHAR)             
                    AND  (@phytypeid is null or b.id = @phytypeid)          
       and (@postname is null or a.postname = @postname )            
                   AND (@deptname is null or a.departmentdivision = @deptname)    
       and a.Confidentialpost='1'  
        union            
        SELECT Distinct [referenceno],             
                   [candidatename],             
                   [typename]             
            FROM   (SELECT [registrationnumber] [referenceno],             
                     b.[postname],            
          b.[deptname] departmentdivision, d.Confidentialpost,            
                           dbo.Candidate_FullName(a.[firstname],a.[middlename],a.[lastname]) [candidatename],            
                           CASE             
                             WHEN discrolallow = 'Completed' THEN 1             
                             WHEN discrolallow = 'Reschedule' THEN 1             
        WHEN discrolallow = 'Yes' THEN 10            
                             ELSE discrolallow             
                           END discrolallow,             
                           CASE             
         WHEN conflictallow = 'Completed' THEN 2             
                             WHEN conflictallow = 'Reschedule' THEN 2             
        WHEN conflictallow = 'Yes' THEN 10            
                             ELSE conflictallow             
                           END conflictallow,             
                           CASE             
                             WHEN iqallow = 'Completed' THEN 3             
                             WHEN iqallow = 'Reschedule' THEN 3             
        WHEN iqallow = 'Yes' THEN 10            
                             ELSE iqallow             
                           END iqallow,             
     CASE             
                             WHEN eqallow = 'Completed' THEN 4             
                             WHEN eqallow = 'Reschedule' THEN 4             
        WHEN eqallow = 'Yes' THEN 10            
                             ELSE eqallow             
                           END eqallow ,            
          CASE             
                             WHEN bigfiveallow = 'Completed' THEN 5             
                             WHEN bigfiveallow = 'Reschedule' THEN 5             
        WHEN bigfiveallow = 'Yes' THEN 10            
                             ELSE bigfiveallow             
                           END bigfiveallow ,            
         CASE             
                             WHEN firoballow = 'Completed' THEN 6             
                             WHEN firoballow = 'Reschedule' THEN 6             
        WHEN firoballow = 'Yes' THEN 10            
                             ELSE firoballow             
                           END firoballow,            
         CASE             
                             WHEN myersbriggsallow = 'Completed' THEN 7             
                             WHEN myersbriggsallow = 'Reschedule' THEN 7             
        WHEN myersbriggsallow = 'Yes' THEN 10            
                             ELSE myersbriggsallow             
                           END myersbriggsallow          
                    FROM   [trecruitcanbasicdtls] a,[vw_apppost] b,[dbo].[trecruitcandidatesignup] c            
                            ,[dbo].[trecruitpostlocationmap] d  
                    WHERE              
                                       
                             myersbriggsallow IN ( 'Completed', 'Reschedule' )             
                                        
       and a.candidateid=c.candidateid            
       and c.username=b.username  
     and b.postid=d.postid and b.locid=d.locid) a,             
                   [dbo].[trecuitpsycycotesttype] b             
            WHERE  a.myersbriggsallow= Cast(b.[id] AS VARCHAR)             
                    AND  (@phytypeid is null or b.id = @phytypeid)          
       and (@postname is null or a.postname = @postname )            
    AND (@deptname is null or a.departmentdivision = @deptname)   
  and a.Confidentialpost='1'  
       order by referenceno desc          
        END             
            
      IF @action = 'Selecttypewiseotcandidate'             
        BEGIN             
            SELECT Distinct [referenceno],             
                   [candidatename],             
                   [typename]             
            FROM   (SELECT             [registrationnumber][referenceno],             
                           dbo.Candidate_FullName(a.[firstname],a.[middlename],a.[lastname]) [candidatename],             
                           CASE             
                             WHEN discrolallow = 'Completed' THEN 1             
                             WHEN discrolallow = 'Reschedule' THEN 1             
        WHEN discrolallow = 'Yes' THEN 10            
                             ELSE discrolallow             
                           END discrolallow,             
                           CASE             
                             WHEN conflictallow = 'Completed' THEN 2             
                             WHEN conflictallow = 'Reschedule' THEN 2             
        WHEN conflictallow = 'Yes' THEN 10            
                             ELSE conflictallow             
                           END conflictallow,             
                           CASE             
                             WHEN iqallow = 'Completed' THEN 3             
                             WHEN iqallow = 'Reschedule' THEN 3             
        WHEN iqallow = 'Yes' THEN 10            
                             ELSE iqallow             
                           END iqallow,             
                           CASE             
                             WHEN eqallow = 'Completed' THEN 4             
                             WHEN eqallow = 'Reschedule' THEN 4             
        WHEN eqallow = 'Yes' THEN 10            
                             ELSE eqallow             
                           END eqallow,            
         CASE             
                             WHEN bigfiveallow = 'Completed' THEN 5             
     WHEN bigfiveallow = 'Reschedule' THEN 5             
        WHEN bigfiveallow = 'Yes' THEN 10            
                             ELSE bigfiveallow             
                           END bigfiveallow ,            
          CASE             
                             WHEN firoballow = 'Completed' THEN 6             
                             WHEN firoballow = 'Reschedule' THEN 6             
        WHEN firoballow = 'Yes' THEN 10            
                             ELSE firoballow             
                           END firoballow,            
         CASE             
                             WHEN myersbriggsallow = 'Completed' THEN 7             
                             WHEN myersbriggsallow = 'Reschedule' THEN 7             
        WHEN myersbriggsallow = 'Yes' THEN 10            
                             ELSE myersbriggsallow             
                           END myersbriggsallow               
                    FROM   [trecruitcanbasicdtls] a,[trecruitotherpost] b            
                    WHERE   discrolallow IN ( 'Completed', 'Reschedule' )             
                                        
       and a.candidateid=b.candidateid) a,             
                   [dbo].[trecuitpsycycotesttype] b             
       WHERE  a.discrolallow = Cast(b.[id] AS VARCHAR)             
                    AND  (@phytypeid is null or b.id = @phytypeid)          
            
       union            
            
       SELECT Distinct [referenceno],             
                   [candidatename],             
                   [typename]             
            FROM   (SELECT             [registrationnumber][referenceno],             
                           dbo.Candidate_FullName(a.[firstname],a.[middlename],a.[lastname]) [candidatename],             
                           CASE             
                             WHEN discrolallow = 'Completed' THEN 1             
                             WHEN discrolallow = 'Reschedule' THEN 1             
        WHEN discrolallow = 'Yes' THEN 10            
                             ELSE discrolallow             
                           END discrolallow,             
                           CASE             
                             WHEN conflictallow = 'Completed' THEN 2             
                             WHEN conflictallow = 'Reschedule' THEN 2             
        WHEN conflictallow = 'Yes' THEN 10            
  ELSE conflictallow             
                           END conflictallow,             
                           CASE             
                             WHEN iqallow = 'Completed' THEN 3             
                             WHEN iqallow = 'Reschedule' THEN 3             
        WHEN iqallow = 'Yes' THEN 10            
                             ELSE iqallow             
                           END iqallow,             
                           CASE             
                             WHEN eqallow = 'Completed' THEN 4             
                             WHEN eqallow = 'Reschedule' THEN 4             
        WHEN eqallow = 'Yes' THEN 10            
                             ELSE eqallow             
                           END eqallow ,            
         CASE             
                             WHEN bigfiveallow = 'Completed' THEN 5             
                             WHEN bigfiveallow = 'Reschedule' THEN 5             
        WHEN bigfiveallow = 'Yes' THEN 10            
                             ELSE bigfiveallow             
                           END bigfiveallow,            
          CASE             
                             WHEN firoballow = 'Completed' THEN 6             
                             WHEN firoballow = 'Reschedule' THEN 6             
        WHEN firoballow = 'Yes' THEN 10            
                             ELSE firoballow             
                           END firoballow,            
         CASE             
                             WHEN myersbriggsallow = 'Completed' THEN 7             
                             WHEN myersbriggsallow = 'Reschedule' THEN 7             
        WHEN myersbriggsallow = 'Yes' THEN 10            
                             ELSE myersbriggsallow             
                           END myersbriggsallow               
                    FROM  [trecruitcanbasicdtls] a,[trecruitotherpost] b            
                    WHERE    conflictallow IN ( 'Completed', 'Reschedule' )             
                                       
       and a.candidateid=b.candidateid) a,             
                   [dbo].[trecuitpsycycotesttype] b             
            WHERE  a.conflictallow = Cast(b.[id] AS VARCHAR)             
                   AND  (@phytypeid is null or b.id = @phytypeid)          
       union            
            
       SELECT Distinct [referenceno],             
                   [candidatename],             
                   [typename]             
            FROM   (SELECT  [registrationnumber][referenceno],             
                           dbo.Candidate_FullName(a.[firstname],a.[middlename],a.[lastname]) [candidatename],          
                           CASE             
                             WHEN discrolallow = 'Completed' THEN 1             
                             WHEN discrolallow = 'Reschedule' THEN 1             
        WHEN discrolallow = 'Yes' THEN 10            
                             ELSE discrolallow             
                           END discrolallow,             
                           CASE             
                             WHEN conflictallow = 'Completed' THEN 2             
                             WHEN conflictallow = 'Reschedule' THEN 2             
        WHEN conflictallow = 'Yes' THEN 10            
                             ELSE conflictallow             
                           END conflictallow,             
                           CASE             
                             WHEN iqallow = 'Completed' THEN 3             
                             WHEN iqallow = 'Reschedule' THEN 3             
        WHEN iqallow = 'Yes' THEN 10            
                             ELSE iqallow             
                           END iqallow,             
                           CASE             
                             WHEN eqallow = 'Completed' THEN 4             
                             WHEN eqallow = 'Reschedule' THEN 4             
        WHEN eqallow = 'Yes' THEN 10            
                             ELSE eqallow             
                           END eqallow ,            
         CASE             
                             WHEN bigfiveallow = 'Completed' THEN 5             
                             WHEN bigfiveallow = 'Reschedule' THEN 5             
        WHEN bigfiveallow = 'Yes' THEN 10            
                             ELSE bigfiveallow             
                           END bigfiveallow ,            
          CASE             
                             WHEN firoballow = 'Completed' THEN 6             
                   WHEN firoballow = 'Reschedule' THEN 6             
        WHEN firoballow = 'Yes' THEN 10            
                             ELSE firoballow             
                         END firoballow ,            
       CASE             
                             WHEN myersbriggsallow = 'Completed' THEN 7             
                             WHEN myersbriggsallow = 'Reschedule' THEN 7             
        WHEN myersbriggsallow = 'Yes' THEN 10            
                             ELSE myersbriggsallow             
                           END myersbriggsallow             
                    FROM   [trecruitcanbasicdtls] a,[trecruitotherpost] b            
                    WHERE    eqallow IN ( 'Completed', 'Reschedule' )             
                                       
       and a.candidateid=b.candidateid) a,             
                   [dbo].[trecuitpsycycotesttype] b             
            WHERE  a.eqallow = Cast(b.[id] AS VARCHAR)             
                    AND  (@phytypeid is null or b.id = @phytypeid)          
            
       union            
            
       SELECT Distinct [referenceno],             
                   [candidatename],             
                   [typename]             
            FROM   (SELECT  [registrationnumber][referenceno],             
                           dbo.Candidate_FullName(a.[firstname],a.[middlename],a.[lastname]) [candidatename],            
                           CASE       
                             WHEN discrolallow = 'Completed' THEN 1             
                             WHEN discrolallow = 'Reschedule' THEN 1             
        WHEN discrolallow = 'Yes' THEN 10            
                             ELSE discrolallow             
                           END discrolallow,             
                           CASE             
                             WHEN conflictallow = 'Completed' THEN 2             
                             WHEN conflictallow = 'Reschedule' THEN 2             
        WHEN conflictallow = 'Yes' THEN 10            
                             ELSE conflictallow             
                           END conflictallow,             
                           CASE             
                             WHEN iqallow = 'Completed' THEN 3             
                             WHEN iqallow = 'Reschedule' THEN 3             
        WHEN iqallow = 'Yes' THEN 10            
                             ELSE iqallow             
                           END iqallow,             
                           CASE             
               WHEN eqallow = 'Completed' THEN 4             
                             WHEN eqallow = 'Reschedule' THEN 4             
        WHEN eqallow = 'Yes' THEN 10            
                             ELSE eqallow             
                           END eqallow ,            
         CASE             
                             WHEN bigfiveallow = 'Completed' THEN 5             
                             WHEN bigfiveallow = 'Reschedule' THEN 5             
        WHEN bigfiveallow = 'Yes' THEN 10            
               ELSE bigfiveallow             
                           END bigfiveallow ,            
          CASE             
                             WHEN firoballow = 'Completed' THEN 6             
                             WHEN firoballow = 'Reschedule' THEN 6             
        WHEN firoballow = 'Yes' THEN 10            
                             ELSE firoballow             
                           END firoballow,            
         CASE             
                             WHEN myersbriggsallow = 'Completed' THEN 7             
                             WHEN myersbriggsallow = 'Reschedule' THEN 7             
        WHEN myersbriggsallow = 'Yes' THEN 10            
                             ELSE myersbriggsallow             
                           END myersbriggsallow              
                    FROM   [trecruitcanbasicdtls] a,[trecruitotherpost] b            
                    WHERE    iqallow IN ( 'Completed', 'Reschedule' )             
                                       
       and a.candidateid=b.candidateid) a,             
                   [dbo].[trecuitpsycycotesttype] b             
            WHERE  a.iqallow = Cast(b.[id] AS VARCHAR)             
                    AND  (@phytypeid is null or b.id = @phytypeid)          
   union            
            
       SELECT Distinct [referenceno],             
                   [candidatename],             
                   [typename]             
            FROM   (SELECT  [registrationnumber][referenceno],             
                           dbo.Candidate_FullName(a.[firstname],a.[middlename],a.[lastname]) [candidatename],            
                           CASE             
                             WHEN discrolallow = 'Completed' THEN 1             
                             WHEN discrolallow = 'Reschedule' THEN 1             
        WHEN discrolallow = 'Yes' THEN 10            
                             ELSE discrolallow             
                           END discrolallow,             
                           CASE             
                             WHEN conflictallow = 'Completed' THEN 2             
                             WHEN conflictallow = 'Reschedule' THEN 2             
        WHEN conflictallow = 'Yes' THEN 10            
                             ELSE conflictallow             
                           END conflictallow,             
                           CASE             
                             WHEN iqallow = 'Completed' THEN 3             
                             WHEN iqallow = 'Reschedule' THEN 3             
        WHEN iqallow = 'Yes' THEN 10            
                             ELSE iqallow             
                           END iqallow,             
                           CASE      
                             WHEN eqallow = 'Completed' THEN 4             
                             WHEN eqallow = 'Reschedule' THEN 4             
        WHEN eqallow = 'Yes' THEN 10            
                             ELSE eqallow             
                           END eqallow ,            
         CASE             
                             WHEN bigfiveallow = 'Completed' THEN 5             
                             WHEN bigfiveallow = 'Reschedule' THEN 5             
        WHEN bigfiveallow = 'Yes' THEN 10            
                             ELSE bigfiveallow             
                           END bigfiveallow ,            
          CASE             
                             WHEN firoballow = 'Completed' THEN 6             
                             WHEN firoballow = 'Reschedule' THEN 6             
        WHEN firoballow = 'Yes' THEN 10            
                             ELSE firoballow             
                           END firoballow,            
         CASE             
                             WHEN myersbriggsallow = 'Completed' THEN 7             
                             WHEN myersbriggsallow = 'Reschedule' THEN 7             
        WHEN myersbriggsallow = 'Yes' THEN 10            
                             ELSE myersbriggsallow             
                           END myersbriggsallow              
                    FROM   [trecruitcanbasicdtls] a,[trecruitotherpost] b            
                    WHERE  bigfiveallow IN ( 'Completed', 'Reschedule' )             
                                       
       and a.candidateid=b.candidateid) a,             
             [dbo].[trecuitpsycycotesttype] b             
            WHERE  a.bigfiveallow = Cast(b.[id] AS VARCHAR)             
                   AND  (@phytypeid is null or b.id = @phytypeid)          
        union            
            
       SELECT Distinct [referenceno],             
                   [candidatename],             
                   [typename]             
            FROM   (SELECT  [registrationnumber][referenceno],             
                           dbo.Candidate_FullName(a.[firstname],a.[middlename],a.[lastname]) [candidatename],             
                           CASE             
                             WHEN discrolallow = 'Completed' THEN 1             
                             WHEN discrolallow = 'Reschedule' THEN 1             
        WHEN discrolallow = 'Yes' THEN 10            
                             ELSE discrolallow             
                           END discrolallow,             
                           CASE             
                             WHEN conflictallow = 'Completed' THEN 2             
                             WHEN conflictallow = 'Reschedule' THEN 2             
        WHEN conflictallow = 'Yes' THEN 10            
                             ELSE conflictallow             
                           END conflictallow,             
                           CASE             
                             WHEN iqallow = 'Completed' THEN 3             
                             WHEN iqallow = 'Reschedule' THEN 3             
        WHEN iqallow = 'Yes' THEN 10            
                             ELSE iqallow             
                           END iqallow,            
                           CASE             
                             WHEN eqallow = 'Completed' THEN 4             
                             WHEN eqallow = 'Reschedule' THEN 4             
        WHEN eqallow = 'Yes' THEN 10            
                             ELSE eqallow             
                           END eqallow ,            
         CASE             
                             WHEN bigfiveallow = 'Completed' THEN 5             
                             WHEN bigfiveallow = 'Reschedule' THEN 5             
        WHEN bigfiveallow = 'Yes' THEN 10            
                             ELSE bigfiveallow             
       END bigfiveallow ,            
          CASE             
                             WHEN firoballow = 'Completed' THEN 6           
                             WHEN firoballow = 'Reschedule' THEN 6             
        WHEN firoballow = 'Yes' THEN 10            
                             ELSE firoballow             
                           END firoballow,            
         CASE             
                             WHEN myersbriggsallow = 'Completed' THEN 7             
                             WHEN myersbriggsallow = 'Reschedule' THEN 7             
        WHEN myersbriggsallow = 'Yes' THEN 10            
                             ELSE myersbriggsallow             
                           END myersbriggsallow              
                    FROM   [trecruitcanbasicdtls] a,[trecruitotherpost] b            
                    WHERE    firoballow IN ( 'Completed', 'Reschedule' )             
                                       
       and a.candidateid=b.candidateid) a,             
                   [dbo].[trecuitpsycycotesttype] b             
            WHERE  a.firoballow = Cast(b.[id] AS VARCHAR)             
                    AND  (@phytypeid is null or b.id = @phytypeid)          
           union            
            
       SELECT Distinct [referenceno],             
                   [candidatename],             
                   [typename]             
            FROM   (SELECT  [registrationnumber][referenceno],             
                           dbo.Candidate_FullName(a.[firstname],a.[middlename],a.[lastname]) [candidatename],            
                           CASE             
                             WHEN discrolallow = 'Completed' THEN 1             
                             WHEN discrolallow = 'Reschedule' THEN 1             
        WHEN discrolallow = 'Yes' THEN 10            
                             ELSE discrolallow             
                           END discrolallow,             
                           CASE             
                             WHEN conflictallow = 'Completed' THEN 2             
          WHEN conflictallow = 'Reschedule' THEN 2             
        WHEN conflictallow = 'Yes' THEN 10            
                             ELSE conflictallow             
                           END conflictallow,             
                           CASE             
                            WHEN iqallow = 'Completed' THEN 3             
                             WHEN iqallow = 'Reschedule' THEN 3             
        WHEN iqallow = 'Yes' THEN 10            
                             ELSE iqallow             
END iqallow,             
                           CASE             
                             WHEN eqallow = 'Completed' THEN 4             
                             WHEN eqallow = 'Reschedule' THEN 4             
        WHEN eqallow = 'Yes' THEN 10            
                             ELSE eqallow             
                           END eqallow ,            
         CASE             
                             WHEN bigfiveallow = 'Completed' THEN 5             
                             WHEN bigfiveallow = 'Reschedule' THEN 5             
        WHEN bigfiveallow = 'Yes' THEN 10            
                             ELSE bigfiveallow             
                           END bigfiveallow ,            
          CASE             
                             WHEN firoballow = 'Completed' THEN 6             
                             WHEN firoballow = 'Reschedule' THEN 6             
        WHEN firoballow = 'Yes' THEN 10            
                             ELSE firoballow             
                           END firoballow,            
         CASE             
                             WHEN myersbriggsallow = 'Completed' THEN 7             
                             WHEN myersbriggsallow = 'Reschedule' THEN 7             
    WHEN myersbriggsallow = 'Yes' THEN 10            
                             ELSE myersbriggsallow             
                           END myersbriggsallow              
                    FROM   [trecruitcanbasicdtls] a,[trecruitotherpost] b            
                    WHERE    myersbriggsallow IN ( 'Completed', 'Reschedule' )             
                                       
       and a.candidateid=b.candidateid) a,             
                   [dbo].[trecuitpsycycotesttype] b             
            WHERE  a.myersbriggsallow = Cast(b.[id] AS VARCHAR)             
                    AND  (@phytypeid is null or b.id = @phytypeid)          
          
       order by referenceno desc          
        END             
            
      IF @action = 'Selectquesans'             
        BEGIN             
            SELECT [disquestype],             
                   [quesserialno],             
                   [question],             
                   f.[answer]             
            FROM   [trecruitdiscrolcandidatedtls] a,             
                   [dbo].[trecruitdiscrolqusdtls] b,             
                   [dbo].[trecruitdiscrolquestype] c,             
                   [dbo].[trecruitdiscrolansdtls]f,             
                   [dbo].[trecruitcanbasicdtls] d,             
                   [dbo].[languages]e             
            WHERE  a.[languageid] = b.[languageid]             
                   AND a.[questionid] = b.[quesserialno]             
                   AND b.[disquestypeid] = c.[id]             
                   AND a.[candidateid] = d.[candidateid]             
                   AND a.[languageid] = e.[id]             
                   AND a.answer = f.number             
                   AND a.[languageid] = f.[languageid]             
                   AND a.candidateid = @candidateid             
                   AND [candidateattemexam] = @candidateattemexam             
            ORDER  BY [quesserialno]             
        END             
            
      IF @action = 'Reschedule'             
        BEGIN             
            --SELECT @candiscrolallow = [discrolallow]             
            --FROM   [Recruitment].[dbo].[trecruittraker]             
            --WHERE  [candidateid] = @candidateid             
            --GROUP  BY [discrolallow],             
            --          [conflictallow],             
            --          [iqallow],             
            --          [eqallow]             
            
   SELECT @candiscrolallow = [discrolallow]             
            FROM   [dbo].[trecruitcanbasicdtls]            
            WHERE  [candidateid] = @candidateid             
            GROUP  BY [discrolallow],             
                      [conflictallow],             
                      [iqallow],             
                      [eqallow]          
            
                         
            IF @candiscrolallow = 'Completed'             
              BEGIN             
                  UPDATE [trecruitcanbasicdtls]             
                  SET    [discrolallow] = 'Reschedule'             
                  WHERE  [candidateid] = @candidateid             
              END             
            ELSE             
              BEGIN             
                  SET @message=1             
              END             
        END             
            
      IF @action = 'SELECTEXAMNO'             
    BEGIN             
            SELECT [attemexam],             
                   CASE             
                     WHEN [attemexam] = 1 THEN Cast('1st Exam' AS VARCHAR)             
                     WHEN [attemexam] = 2 THEN Cast('2nd Exam'AS VARCHAR)             
                     WHEN [attemexam] = 3 THEN Cast('3rd Exam'AS VARCHAR)             
                     ELSE Cast([attemexam]AS VARCHAR) + '' + 'th Exam'             
                   END [attemexamtext]             
            FROM   [trecruitdiscrolexamdtls]             
            WHERE  candidateid = @candidateid             
                   AND finalsubmit = 'Yes'             
            ORDER  BY [attemexam]             
        END             
            
      IF @action = 'Selecttypewisetotalno'             
        BEGIN             
            SELECT c.[disquestype],             
                   a.questionid,             
                   a.answer,             
                   totscore             
            FROM   [trecruitdiscrolcandidatedtls] a,             
                   [dbo].[trecruitdiscrolqusdtls] b,             
                   [dbo].[trecruitdiscrolquestype] c,             
                   [dbo].[trecruitdiscrolansdtls]f,             
                   [dbo].[trecruitcanbasicdtls] d,             
                   [dbo].[languages]e,             
                  (SELECT c.[disquestype],             
                           Sum (a.answer)totscore             
                    FROM   [trecruitdiscrolcandidatedtls] a,             
                           [dbo].[trecruitdiscrolqusdtls] b,             
                           [dbo].[trecruitdiscrolquestype] c,             
                           [dbo].[trecruitdiscrolansdtls]f,             
                           [dbo].[trecruitcanbasicdtls] d,             
                           [dbo].[languages]e             
                    WHERE  a.[languageid] = b.[languageid]             
                           AND a.[questionid] = b.[quesserialno]             
                           AND b.[disquestypeid] = c.[id]             
                           AND a.[candidateid] = d.[candidateid]             
                           AND a.[languageid] = e.[id]             
                            AND a.answer = f.[number]            
         and a.[languageid]=f.[languageid]               
                           AND a.candidateid = @candidateid             
                           AND [candidateattemexam] = @candidateattemexam             
                    GROUP  BY c.[disquestype]) z             
            WHERE  a.[languageid] = b.[languageid]             
                   AND a.[questionid] = b.[quesserialno]             
                   AND b.[disquestypeid] = c.[id]             
                   AND a.[candidateid] = d.[candidateid]             
                   AND a.[languageid] = e.[id]             
                    AND a.answer = f.[number]            
     and a.[languageid]=f.[languageid]               
                   AND a.candidateid = @candidateid             
                   AND [candidateattemexam] = @candidateattemexam             
                   AND c.[disquestype] = z.[disquestype]             
            ORDER  BY [disquestype]             
        END             
            
      IF @action = 'Discrolgraph'             
        BEGIN             
            SELECT ( d.totscore * 1.363636 ) TIGERfinalscore,             
                   ( a.totscore * 2 )        CHAMELEONfinalscore,             
          ( e.totscore * 2.1428 )   TURTLEfinalscore,             
                   ( b.totscore * 1.363636 ) EAGLEfinalscore,             
                   ( a.totscore * 2 )        SALMONfinalscore             
            FROM   (SELECT c.[disquestype],             
                           a.candidateid,             
                           Sum (a.answer)totscore             
                    FROM  [trecruitdiscrolcandidatedtls] a,             
                           [dbo].[trecruitdiscrolqusdtls] b,             
                           [dbo].[trecruitdiscrolquestype] c,             
                           [dbo].[trecruitdiscrolansdtls]f,             
                           [dbo].[trecruitcanbasicdtls] d,             
                           [dbo].[languages]e             
                    WHERE  a.[languageid] = b.[languageid]             
                           AND a.[questionid] = b.[quesserialno]             
                           AND b.[disquestypeid] = c.[id]             
                           AND a.[candidateid] = d.[candidateid]             
                           AND a.[languageid] = e.[id]             
                            AND a.answer = f.[number]            
         and a.[languageid]=f.[languageid]                
                           AND a.candidateid = @candidateid             
                           AND [candidateattemexam] = @candidateattemexam             
                           AND c.[disquestype] = 'CHAMELEON'             
                    GROUP  BY c.[disquestype],             
                              a.candidateid) a,             
                   (SELECT c.[disquestype],             
                           a.candidateid,             
                           Sum (a.answer)totscore             
                    FROM   [trecruitdiscrolcandidatedtls] a,             
                           [dbo].[trecruitdiscrolqusdtls] b,             
                           [dbo].[trecruitdiscrolquestype] c,             
 [dbo].[trecruitdiscrolansdtls]f,             
                           [dbo].[trecruitcanbasicdtls] d,             
                           [dbo].[languages]e             
                    WHERE  a.[languageid] = b.[languageid]             
                           AND a.[questionid] = b.[quesserialno]             
                           AND b.[disquestypeid] = c.[id]             
                           AND a.[candidateid] = d.[candidateid]             
                           AND a.[languageid] = e.[id]             
                            AND a.answer = f.[number]            
         and a.[languageid]=f.[languageid]               
                           AND a.candidateid = @candidateid             
                           AND [candidateattemexam] = @candidateattemexam             
                           AND c.[disquestype] = 'EAGLE'             
                    GROUP  BY c.[disquestype],             
                              a.candidateid) b,             
                   (SELECT c.[disquestype],             
                           a.candidateid,             
                           Sum (a.answer)totscore             
                    FROM   [trecruitdiscrolcandidatedtls] a,             
                           [dbo].[trecruitdiscrolqusdtls] b,             
                           [dbo].[trecruitdiscrolquestype] c,             
                           [dbo].[trecruitdiscrolansdtls]f,             
                           [dbo].[trecruitcanbasicdtls] d,             
                           [dbo].[languages]e             
                    WHERE  a.[languageid] = b.[languageid]             
                           AND a.[questionid] = b.[quesserialno]             
                           AND b.[disquestypeid] = c.[id]             
                           AND a.[candidateid] = d.[candidateid]             
                           AND a.[languageid] = e.[id]             
                            AND a.answer = f.[number]            
         and a.[languageid]=f.[languageid]               
                    AND a.candidateid = @candidateid             
                           AND [candidateattemexam] = @candidateattemexam             
                           AND c.[disquestype] = 'SALMON'             
                    GROUP  BY c.[disquestype],             
                              a.candidateid) c,             
    (SELECT c.[disquestype],             
                           a.candidateid,             
                           Sum (a.answer)totscore             
                    FROM   [trecruitdiscrolcandidatedtls] a,             
                           [dbo].[trecruitdiscrolqusdtls] b,             
                           [dbo].[trecruitdiscrolquestype] c,             
                           [dbo].[trecruitdiscrolansdtls]f,             
                           [dbo].[trecruitcanbasicdtls] d,             
                           [dbo].[languages]e             
                    WHERE  a.[languageid] = b.[languageid]             
                           AND a.[questionid] = b.[quesserialno]             
                           AND b.[disquestypeid] = c.[id]             
                           AND a.[candidateid] = d.[candidateid]             
                           AND a.[languageid] = e.[id]             
                            AND a.answer = f.[number]            
         and a.[languageid]=f.[languageid]               
                           AND a.candidateid = @candidateid             
                           AND [candidateattemexam] = @candidateattemexam             
                           AND c.[disquestype] = 'TIGER'             
                    GROUP  BY c.[disquestype],             
                              a.candidateid) d,             
                   (SELECT c.[disquestype],             
                           a.candidateid,             
                           Sum (a.answer)totscore             
                    FROM   [trecruitdiscrolcandidatedtls] a,             
                           [dbo].[trecruitdiscrolqusdtls] b,             
                           [dbo].[trecruitdiscrolquestype] c,             
    [dbo].[trecruitdiscrolansdtls]f,             
                           [dbo].[trecruitcanbasicdtls] d,             
                           [dbo].[languages]e             
                    WHERE  a.[languageid] = b.[languageid]             
                           AND a.[questionid] = b.[quesserialno]             
                           AND b.[disquestypeid] = c.[id]             
                           AND a.[candidateid] = d.[candidateid]             
              AND a.[languageid] = e.[id]             
                            AND a.answer = f.[number]            
         and a.[languageid]=f.[languageid]               
                           AND a.candidateid = @candidateid             
                           AND [candidateattemexam] = @candidateattemexam             
                           AND c.[disquestype] = 'TURTLE'             
                    GROUP  BY c.[disquestype],             
                              a.candidateid) e             
            WHERE  a.candidateid = b.candidateid             
                   AND a.candidateid = c.candidateid             
                   AND a.candidateid = d.candidateid             
                   AND a.candidateid = e.candidateid             
        END             
            
      IF @action = 'Activeinactiveresbutton'             
        BEGIN             
            SELECT             
                   a.[discrolallow]             
            FROM   [dbo].[trecruitcanbasicdtls] a                            
            WHERE a.candidateid = @candidateid             
        END             
  END 
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: Languages, tdiscrolscoremappingChameleon, tdiscrolscoremappingEagle, tdiscrolscoremappingSalmon, tdiscrolscoremappingTiger, tdiscrolscoremappingTurtle, trecruitcanbasicdtls, trecruitdiscrolansdtls, trecruitdiscrolcandidatedtls, trecruitdiscrolquestype, trecruitdiscrolqusdtls */
/****** Object:  StoredProcedure [dbo].[procdisreport]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
CREATE PROC [dbo].[procdisreport] @candidateattemexam INT=NULL,   
                                 @registrationnumber VARCHAR(200)=NULL   
AS   
    DECLARE @candidateid INT   
    DECLARE @exquesset INT   
  
  BEGIN   
      SELECT @candidateid = candidateid   
      FROM   [dbo].[trecruitcanbasicdtls]   
      WHERE  registrationnumber = @registrationnumber   
  
      --SELECT @exquesset = exquesset   
      --FROM   (SELECT DISTINCT ( [exquesset] ) exquesset   
      --        FROM   trecruitdiscrolcandidatedtls   
      --        WHERE  [candidateattemexam] = @candidateattemexam   
      --               AND candidateid = @candidateid)a   
  
      SELECT [disquestype],   
             totscore score ,  
    CASE [disquestype]   
                  WHEN 'TIGER' THEN (Select  [scoreinmap] from [dbo].[tdiscrolscoremappingTiger] where [score]=totscore)  
                  WHEN 'CHAMELEON' THEN (Select  [scoreinmap] from [dbo].[tdiscrolscoremappingChameleon] where [score]=totscore)  
                  WHEN 'TURTLE' THEN (Select  [scoreinmap] from [dbo].[tdiscrolscoremappingTurtle] where [score]=totscore)  
                  WHEN 'EAGLE' THEN (Select  [scoreinmap] from [dbo].[tdiscrolscoremappingEagle] where [score]=totscore)  
                  WHEN 'SALMON' THEN (Select  [scoreinmap] from [dbo].[tdiscrolscoremappingSalmon] where [score]=totscore)  
                  ELSE [disquestype]   
                END totscore , discrolallow  
      FROM   (SELECT c.[disquestype],   
                     (Sum (a.answer))totscore ,d.discrolallow  
              FROM   [dbo].[trecruitdiscrolcandidatedtls] a,   
                     [dbo].[trecruitdiscrolqusdtls] b,   
                     [dbo].[trecruitdiscrolquestype] c,   
                     [dbo].[trecruitdiscrolansdtls]f,   
                     [dbo].[trecruitcanbasicdtls] d,   
                     [dbo].[languages]e   
              WHERE  a.[languageid] = b.[languageid]   
                     AND a.[questionid] = b.[quesserialno]   
                     AND b.[disquestypeid] = c.[id]   
                     AND a.[candidateid] = d.[candidateid]   
                     AND a.[languageid] = e.[id]   
                     AND a.answer = f.[number]   
                     AND a.[languageid] = f.[languageid]   
                     AND a.candidateid = @candidateid   
                     AND [candidateattemexam] = @candidateattemexam   
                     AND c.[disquestype] = 'TIGER'   
                    -- AND b.[queslanset] = @exquesset   
              GROUP  BY c.[disquestype],   
                        a.candidateid ,
						d.discrolallow
              UNION   
              SELECT c.[disquestype],   
                     ( Sum (a.answer))totscore , d.discrolallow   
              FROM   [dbo].[trecruitdiscrolcandidatedtls] a,   
                     [dbo].[trecruitdiscrolqusdtls] b,   
                     [dbo].[trecruitdiscrolquestype] c,   
                     [dbo].[trecruitdiscrolansdtls]f,   
                     [dbo].[trecruitcanbasicdtls] d,   
                     [dbo].[languages]e   
              WHERE  a.[languageid] = b.[languageid]   
                     AND a.[questionid] = b.[quesserialno]   
                     AND b.[disquestypeid] = c.[id]   
                     AND a.[candidateid] = d.[candidateid]   
                     AND a.[languageid] = e.[id]   
                     AND a.answer = f.[number]   
                     AND a.[languageid] = f.[languageid]   
                     AND a.candidateid = @candidateid   
                     AND [candidateattemexam] = @candidateattemexam   
                     AND c.[disquestype] = 'CHAMELEON'   
                    -- AND b.[queslanset] = @exquesset   
              GROUP  BY c.[disquestype],   
                        a.candidateid ,
						d.discrolallow
              UNION   
              SELECT c.[disquestype],   
                     ( Sum (a.answer))totscore  ,d.discrolallow 
              FROM   [dbo].[trecruitdiscrolcandidatedtls] a,   
                     [dbo].[trecruitdiscrolqusdtls] b,   
                     [dbo].[trecruitdiscrolquestype] c,   
              [dbo].[trecruitdiscrolansdtls]f,   
                     [dbo].[trecruitcanbasicdtls] d,   
                     [dbo].[languages]e   
              WHERE  a.[languageid] = b.[languageid]   
                     AND a.[questionid] = b.[quesserialno]   
                     AND b.[disquestypeid] = c.[id]   
                     AND a.[candidateid] = d.[candidateid]   
                     AND a.[languageid] = e.[id]   
                     AND a.answer = f.[number]   
                     AND a.[languageid] = f.[languageid]   
                     AND a.candidateid = @candidateid   
                     AND [candidateattemexam] = @candidateattemexam   
                     AND c.[disquestype] = 'TURTLE'   
                    -- AND b.[queslanset] = @exquesset   
              GROUP  BY c.[disquestype],   
                        a.candidateid ,
						d.discrolallow
              UNION   
              SELECT c.[disquestype],   
                     ( Sum (a.answer))totscore  ,d.discrolallow 
              FROM   [dbo].[trecruitdiscrolcandidatedtls] a,   
                     [dbo].[trecruitdiscrolqusdtls] b,   
                     [dbo].[trecruitdiscrolquestype] c,   
                     [dbo].[trecruitdiscrolansdtls]f,   
                     [dbo].[trecruitcanbasicdtls] d,   
                     [dbo].[languages]e   
              WHERE  a.[languageid] = b.[languageid]   
                     AND a.[questionid] = b.[quesserialno]   
                     AND b.[disquestypeid] = c.[id]   
                     AND a.[candidateid] = d.[candidateid]   
                     AND a.[languageid] = e.[id]   
                     AND a.answer = f.[number]   
                     AND a.[languageid] = f.[languageid]   
                     AND a.candidateid = @candidateid   
                     AND [candidateattemexam] = @candidateattemexam   
                     AND c.[disquestype] = 'EAGLE'   
                    -- AND b.[queslanset] = @exquesset   
              GROUP  BY c.[disquestype],   
                        a.candidateid ,
						d.discrolallow
              UNION   
              SELECT c.[disquestype],   
                     ( Sum (a.answer))totscore  ,d.discrolallow 
              FROM   [dbo].[trecruitdiscrolcandidatedtls] a,   
                     [dbo].[trecruitdiscrolqusdtls] b,   
                     [dbo].[trecruitdiscrolquestype] c,   
                     [dbo].[trecruitdiscrolansdtls]f,   
                     [dbo].[trecruitcanbasicdtls] d,   
                     [dbo].[languages]e   
              WHERE  a.[languageid] = b.[languageid]   
                     AND a.[questionid] = b.[quesserialno]   
                     AND b.[disquestypeid] = c.[id]   
                     AND a.[candidateid] = d.[candidateid]   
                     AND a.[languageid] = e.[id]   
                     AND a.answer = f.[number]   
                     AND a.[languageid] = f.[languageid]   
                     AND a.candidateid = @candidateid   
                     AND [candidateattemexam] = @candidateattemexam   
                     AND c.[disquestype] = 'SALMON'   
                    -- AND b.[queslanset] = @exquesset   
              GROUP  BY c.[disquestype],   
                        a.candidateid , d.discrolallow)a   
      ORDER  BY CASE [disquestype]   
                  WHEN 'TIGER' THEN '0'   
                  WHEN 'CHAMELEON' THEN '1'   
                  WHEN 'TURTLE' THEN '2'   
                  WHEN 'EAGLE' THEN '3'   
                  WHEN 'SALMON' THEN '4'   
                  ELSE [disquestype]   
                END   
  END 
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: Languages, trecruitcanbasicdtls, trecruitdiscrolansdtls, trecruitdiscrolcandidatedtls, trecruitdiscrolquestype, trecruitdiscrolqusdtls */
/****** Object:  StoredProcedure [dbo].[procdisSALMONtotalno]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                         
						 CREATE proc [dbo].[procdisSALMONtotalno]
						 @candidateattemexam INT=NULL, 
@registrationnumber VARCHAR(200)=NULL 
						 as
						 DECLARE @candidateid INT 
						 begin

						 SELECT @candidateid = candidateid 
      FROM   [dbo].[trecruitcanbasicdtls] 
      WHERE  registrationnumber = @registrationnumber 

						 SELECT 
                           a.questionid, 
                           a.answer
                    FROM   [dbo].[trecruitdiscrolcandidatedtls] a, 
                           [dbo].[trecruitdiscrolqusdtls] b, 
                           [dbo].[trecruitdiscrolquestype] c, 
                           [dbo].[trecruitdiscrolansdtls]f, 
                           [dbo].[trecruitcanbasicdtls] d, 
                           [dbo].[languages]e 
                    WHERE  a.[languageid] = b.[languageid] 
                           AND a.[questionid] = b.[quesserialno] 
                           AND b.[disquestypeid] = c.[id] 
                           AND a.[candidateid] = d.[candidateid] 
                           AND a.[languageid] = e.[id] 
                           AND a.answer = f.[number]
						   and a.[languageid]=f.[languageid]                            
                           AND [candidateattemexam] = @candidateattemexam
                           AND c.[disquestype] = 'SALMON' 
						   and a.candidateid=@candidateid

						   end
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: Languages, trecruitcanbasicdtls, trecruitdiscrolansdtls, trecruitdiscrolcandidatedtls, trecruitdiscrolquestype, trecruitdiscrolqusdtls */
/****** Object:  StoredProcedure [dbo].[procdisTIGERtotalno]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                         
						 CREATE proc [dbo].[procdisTIGERtotalno]
						 @candidateattemexam INT=NULL, 
@registrationnumber VARCHAR(200)=NULL 
						 as
						 DECLARE @candidateid INT 
						 begin

						 SELECT @candidateid = candidateid 
      FROM   [dbo].[trecruitcanbasicdtls] 
      WHERE  registrationnumber = @registrationnumber 

						 SELECT 
                           a.questionid, 
                           a.answer
                    FROM   [dbo].[trecruitdiscrolcandidatedtls] a, 
                           [dbo].[trecruitdiscrolqusdtls] b, 
                           [dbo].[trecruitdiscrolquestype] c, 
                           [dbo].[trecruitdiscrolansdtls]f, 
                           [dbo].[trecruitcanbasicdtls] d, 
                           [dbo].[languages]e 
                    WHERE  a.[languageid] = b.[languageid] 
                           AND a.[questionid] = b.[quesserialno] 
                           AND b.[disquestypeid] = c.[id] 
                           AND a.[candidateid] = d.[candidateid] 
                           AND a.[languageid] = e.[id] 
                           AND a.answer = f.[number]
						   and a.[languageid]=f.[languageid]                            
                           AND [candidateattemexam] = @candidateattemexam
                           AND c.[disquestype] = 'TIGER' 
						   and a.candidateid=@candidateid

						   end
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: Languages, trecruitcanbasicdtls, trecruitdiscrolansdtls, trecruitdiscrolcandidatedtls, trecruitdiscrolquestype, trecruitdiscrolqusdtls */
/****** Object:  StoredProcedure [dbo].[procdisTURTLEtotalno]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                         
						 CREATE proc [dbo].[procdisTURTLEtotalno]
						 @candidateattemexam INT=NULL, 
@registrationnumber VARCHAR(200)=NULL 
						 as
						 DECLARE @candidateid INT 
						 begin

						 SELECT @candidateid = candidateid 
      FROM   [dbo].[trecruitcanbasicdtls] 
      WHERE  registrationnumber = @registrationnumber 

						 SELECT 
                           a.questionid, 
                           a.answer
                    FROM   [dbo].[trecruitdiscrolcandidatedtls] a, 
                           [dbo].[trecruitdiscrolqusdtls] b, 
                           [dbo].[trecruitdiscrolquestype] c, 
                           [dbo].[trecruitdiscrolansdtls]f, 
                           [dbo].[trecruitcanbasicdtls] d, 
                           [dbo].[languages]e 
                    WHERE  a.[languageid] = b.[languageid] 
                           AND a.[questionid] = b.[quesserialno] 
                           AND b.[disquestypeid] = c.[id] 
                           AND a.[candidateid] = d.[candidateid] 
                           AND a.[languageid] = e.[id] 
                           AND a.answer = f.[number]
						   and a.[languageid]=f.[languageid]                            
                           AND [candidateattemexam] = @candidateattemexam
                           AND c.[disquestype] = 'TURTLE' 
						   and a.candidateid=@candidateid

						   end
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: tblDocumentsSynchronization, tcandidateappointmentmapping, tofferlatterdtls, trecruitcanbasicdtls, trecruitcandidatesignup, trecruitconflictexamdtls, trecruitdiscrolexamdtls, trecruiteqexamdtls, trecruitiqexamdtls */
/****** Object:  StoredProcedure [dbo].[procdocumentsynchronizationforexe]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[procdocumentsynchronizationforexe]
@action varchar(100),
@canid int=null,
@totalcandidateout int=null output

as
declare @candidateid int
declare @totalcandidate int =0
begin
if(@action= 'SELECT')
begin
  Select @totalcandidate=count([candidateid]) from  [dbo].[tcandidateappointmentmapping]
  where deleteflag='No' 
  and empno is not null
  and empno not in(Select empno from [dbo].[tblDocumentsSynchronization]
   where [otherdocumentsynchronizationstatus]='Yes')
  if(@totalcandidate > 0)
  begin
      
	  --Select top 1 @candidateid = [candidateid] from  [dbo].[tcandidateappointmentmapping] 
   --   where deleteflag='No' and empno is not null
	  Select top 1 @candidateid = [candidateid] from  [dbo].[tcandidateappointmentmapping]
       where deleteflag='No' 
       and empno is not null
       and empno not in(Select empno from [dbo].[tblDocumentsSynchronization]
       where [otherdocumentsynchronizationstatus]='Yes')
      Select * into #temptestresult
  from 
  (SELECT 
      a.[candidateid],
     --,a.[finalsubmit]
	  case
	  when a.[attemexam] is null then 0
	  when a.[attemexam]='' then 0
	  else  a.[attemexam]
	  end discrolexamno,
     --,a.[attemexam]discrolexamno
	 --,b.[finalsubmit]
	 case
	  when b.[attemexam] is null then 0
	  when b.[attemexam]='' then 0
	  else  b.[attemexam]
	  end eqexamno,
     --,b.[attemexam]eqexamno
	 --,c.[finalsubmit]
	 case
	  when c.[attemexam] is null then 0
	  when c.[attemexam]='' then 0
	  else c.[attemexam]
	  end conflictexamno,
     --,c.[attemexam]conflictexamno
	 --,d.[finalsubmit]
	 case
	  when d.[attemexam] is null then 0
	  when d.[attemexam]='' then 0
	  else d.[attemexam]
	  end iqexamno
     --,d.[attemexam]iqexamno
  FROM 
  (Select candidateid, max([attemexam])[attemexam] from [dbo].[trecruitdiscrolexamdtls]where finalsubmit='Yes' and candidateid=@candidateid group by candidateid )a full join
  (Select candidateid, max([attemexam])[attemexam] from [dbo].[trecruiteqexamdtls] where finalsubmit='Yes' and candidateid=@candidateid group by candidateid )b on a.candidateid=b.candidateid full join
  (Select candidateid, max([attemexam])[attemexam] from [dbo].[trecruitconflictexamdtls] where finalsubmit='Yes' and candidateid=@candidateid group by candidateid )c on a.candidateid=c.candidateid full join
  (Select candidateid, max([attemexam])[attemexam] from [dbo].[trecruitiqexamdtls] where finalsubmit='Yes' and candidateid=@candidateid group by candidateid )d on a.candidateid=d.candidateid)ab
      Select * into #tempbasic
  from
       ( Select a.candidateid, registrationnumber,username from [dbo].[trecruitcanbasicdtls] a, [dbo].[trecruitcandidatesignup]b
		where a.candidateid=b.candidateid
		and a.candidateid=@candidateid)a
      Select * into #tempofferappointment
  from
	(Select
	   a.[candidateid]
      ,a.[appointmentlettertype]
      ,a.[empno]
	  ,b.[offerdcompanycode]
	  from [dbo].[tcandidateappointmentmapping] a,[dbo].[tofferlatterdtls]b
	  where a.[candidateid]=b.[candidateid]
	  and a.deleteflag='No'
	  and b.deleteflag='No'
	  and a.[candidateid]=@candidateid)a

	  Select 
	  a.[candidateid],
	  a.discrolexamno,
	  a.eqexamno,
	  a.conflictexamno,
	  a.iqexamno,
	  b.registrationnumber,
	  b.username,
	  c.[appointmentlettertype],
	  c.[offerdcompanycode],
	  c.[empno]
	  from #temptestresult a,#tempbasic b,#tempofferappointment c
	  where a.[candidateid]=b.[candidateid]
	  and a.[candidateid]=c.[candidateid]


      drop table #temptestresult
      drop table #tempbasic
      drop table #tempofferappointment
	end
	Set @totalcandidateout=@totalcandidate
End
if(@action= 'UPDATESTATUS')
begin
 if exists(Select candidateid from [dbo].[tblDocumentsSynchronization] where candidateid=@canid )
 begin
   update [dbo].[tblDocumentsSynchronization]
   
   set [otherdocumentsynchronizationstatus]='Yes',
       [otherdocumentsynchronizationon]=getdate()
      where  candidateid=@canid
  
 end
 else
 begin
  insert into [dbo].[tblDocumentsSynchronization]
  (
    [candidateid],
    [empno],
    [otherdocumentsynchronizationstatus],
    [otherdocumentsynchronizationon]
  )
  Select 
    candidateid,
	empno,
	'Yes',
	getdate()
	from [dbo].[tcandidateappointmentmapping]
	where candidateid=@canid
	and deleteflag='No'
 end
end
end
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: tempPsychometricTestMapping, test, trecruitcanbasicdtls, trecruitcandidatesignup */
/****** Object:  StoredProcedure [dbo].[proce_MLQReschedule]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE PROC [dbo].[proce_MLQReschedule]             
  @username  NVARCHAR(100)=NULL,    
  @MlqAllowExamUrl nvarchar(max)=NULL    
AS          
 Declare @candidateid bigint    
 Declare @CandidaFullName nvarchar(max)    
 Declare @CandidateMail nvarchar(max)    
begin    
          
    
      SELECT @candidateid = candidateid             
    FROM   [Recruitment].[dbo].[trecruitcandidatesignup]             
    WHERE  [username] = @username       
    
         UPDATE [tempPsychometricTestMapping] SET MlqAllow='Reschedule' WHERE CandidateID=@candidateid    
     
      Declare @tableHTMLReschdule nvarchar(max)    
   DECLARE @mailSubjectReschdule nvarchar(max)    
        -- Candidate full name for personalization    
        SELECT @CandidaFullName = (firstname + ' ' + middlename + ' ' + lastname)    
        FROM trecruitcanbasicdtls     
        WHERE candidateid = @candidateid;    
    
        -- Candidate email    
        SELECT @CandidateMail = MailId     
        FROM trecruitcandidatesignup     
        WHERE CandidateID = @candidateid;    
    
        -- Mark as reschedule    
        UPDATE [tempPsychometricTestMapping]     
        SET MlqAllow = 'Reschedule'     
        WHERE CandidateID = @candidateid;    
    
        SET @mailSubjectReschdule = 'Invitation to Complete the Multifactor Leadership Questionnaire (MLQ)';      
    
        SET @tableHTMLReschdule =       
       '<table style="font-size:16px; font-family:Tahoma; line-height:22px; width:650px;">      
          <tr><td>Dear ' + ISNULL(@CandidaFullName,'Candidate') + ',</td></tr>      
          <tr><td style="height:15px;"></td></tr>      
          <tr><td>As part of our commitment to understanding and developing strong leadership,       
          we would like to invite you to complete the <b>Multifactor Leadership Questionnaire (MLQ)</b>.      
          </td></tr>      
          <tr><td style="height:20px;"></td></tr>      
          <tr><td><b>How to Start:</b><br/>      
          To begin the assessment, please click on the link below:<br/><br/>      
          <a href="' + ISNULL(@MlqAllowExamUrl,'#') + '"       
             style="background-color:#0E7777; color:#ffffff; padding:10px 18px;       
             text-decoration:none; border-radius:6px; font-weight:bold;">      
          Start the MLQ Test</a></td></tr>      
          <tr><td style="height:20px;"></td></tr>      
          <tr><td>The results will help your manager and our leadership team understand your strengths.</td></tr>      
          <tr><td style="height:20px;"></td></tr>      
          <tr><td>If you face any issues, please contact concerned HR, or <a href="mailto:bipro.das@mendine.com">bipro.das@mendine.com</a>.</td></tr>      
          <tr><td style="height:30px;"></td></tr>      
          <tr><td>Thanks & Regards,<br/><i>Mendine HR Team</i></td></tr>      
        </table>';      
    
        -- ✅ Send only if email is available    
        IF ISNULL(@CandidateMail,'') <> ''    
        BEGIN    
            EXEC msdb.dbo.sp_send_dbmail          
                @profile_name = 'Mendine_Recruitment_Profile',          
                @recipients   = @CandidateMail,          
                @subject      = @mailSubjectReschdule,          
                @body         = @tableHTMLReschdule,          
                @importance   = 'HIGH',          
                @body_format  = 'HTML';    
        END    
        ELSE    
        BEGIN    
            PRINT '⚠ No email found for candidate ' + CAST(@candidateid AS VARCHAR);    
        END    
end    
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: Languages, test, trecruitcanbasicdtls, trecruitcandidatesignup, trecruitdiscrolansdtls, trecruitdiscrolcandidatedtls, trecruitdiscrolquestype, trecruitdiscrolqusdtls, trecruiteqansmarks, trecruiteqcandidatedtls, trecruiteqexamdtls, trecruitotherpost, trecruittraker, trecuitpsycycotesttype */
/****** Object:  StoredProcedure [dbo].[proceqhrdtls]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
      
/****** Script for SelectTopNRows command from SSMS  ******/       
CREATE PROC [dbo].[proceqhrdtls] @action             VARCHAR(100)=NULL,       
                                 @phytypeid          INT=NULL,       
                                 @postname           VARCHAR(500)=NULL,       
                                 @deptname           VARCHAR(500)=NULL,       
                                 @candidateattemexam INT=NULL,       
                                 @registrationnumber VARCHAR(200)=NULL,       
                                 @eqallow       VARCHAR(200)=NULL,       
                                 @Message            VARCHAR(200)=NULL       
AS       
    DECLARE @candidateid INT       
    DECLARE @candiscrolallow VARCHAR(200)       
      
  BEGIN       
      SELECT @candidateid = candidateid       
      FROM   [dbo].[trecruitcanbasicdtls]       
      WHERE  registrationnumber = @registrationnumber       
      
        
      
      
      IF @action = 'Selecttypewisecandidate'       
        BEGIN                
      
        SELECT [referenceno],       
                           [candidatename],       
                           [typename]       
            FROM   (SELECT [registrationnumber] [referenceno],       
                     b.[postname],      
          b.[deptname] departmentdivision,      
                           a.[firstname]+' '+a.[middlename]+' '+a.[lastname] [candidatename],       
                           CASE       
                             WHEN discrolallow = 'Completed' THEN 1       
                             WHEN discrolallow = 'Reschedule' THEN 1       
        WHEN discrolallow = 'Yes' THEN 10      
                             ELSE discrolallow       
                           END discrolallow,       
                           CASE       
                             WHEN conflictallow = 'Completed' THEN 2       
                             WHEN conflictallow = 'Reschedule' THEN 2       
        WHEN conflictallow = 'Yes' THEN 10      
                             ELSE conflictallow       
                           END conflictallow,       
                           CASE       
                             WHEN iqallow = 'Completed' THEN 3       
                             WHEN iqallow = 'Reschedule' THEN 3       
        WHEN iqallow = 'Yes' THEN 10      
                             ELSE iqallow       
                           END iqallow,       
                           CASE       
                             WHEN eqallow = 'Completed' THEN 4       
                             WHEN eqallow = 'Reschedule' THEN 4       
        WHEN eqallow = 'Yes' THEN 10      
                             ELSE eqallow       
                           END eqallow       
                    FROM   [dbo].[trecruitcanbasicdtls] a,[dbo].[vw_apppost] b,[dbo].[trecruitcandidatesignup] c      
      
                    WHERE        
                            discrolallow IN ( 'Completed', 'Reschedule' )       
                                  
       and a.candidateid=c.candidateid      
       and c.username=b.username) a,       
                   [dbo].[trecuitpsycycotesttype] b       
            WHERE  a.discrolallow = Cast(b.[id] AS VARCHAR)       
                   AND b.id = @phytypeid       
       and a.postname = @postname       
                   AND a.departmentdivision = @deptname       
       union      
        SELECT [referenceno],       
                   [candidatename],       
                   [typename]       
            FROM   (SELECT [registrationnumber] [referenceno],       
                     b.[postname],      
          b.[deptname] departmentdivision,      
                           a.[firstname]+' '+a.[middlename]+' '+a.[lastname] [candidatename],       
                           CASE       
                             WHEN discrolallow = 'Completed' THEN 1       
                             WHEN discrolallow = 'Reschedule' THEN 1       
        WHEN discrolallow = 'Yes' THEN 10      
                           ELSE discrolallow       
                           END discrolallow,       
                           CASE       
   WHEN conflictallow = 'Completed' THEN 2       
                             WHEN conflictallow = 'Reschedule' THEN 2       
        WHEN conflictallow = 'Yes' THEN 10      
                        ELSE conflictallow       
                           END conflictallow,       
                           CASE       
                             WHEN iqallow = 'Completed' THEN 3       
                             WHEN iqallow = 'Reschedule' THEN 3       
        WHEN iqallow = 'Yes' THEN 10      
                             ELSE iqallow       
                           END iqallow,       
                           CASE       
                             WHEN eqallow = 'Completed' THEN 4       
                             WHEN eqallow = 'Reschedule' THEN 4       
        WHEN eqallow = 'Yes' THEN 10      
                             ELSE eqallow       
                           END eqallow       
                    FROM   [dbo].[trecruitcanbasicdtls] a,[dbo].[vw_apppost] b,[dbo].[trecruitcandidatesignup] c      
      
                    WHERE        
                                 
                             conflictallow IN ( 'Completed', 'Reschedule' )       
                                  
       and a.candidateid=c.candidateid      
       and c.username=b.username) a,       
                   [dbo].[trecuitpsycycotesttype] b       
            WHERE  a.conflictallow= Cast(b.[id] AS VARCHAR)       
                   AND b.id = @phytypeid       
       and a.postname = @postname       
                   AND a.departmentdivision = @deptname      
      
       union      
        SELECT [referenceno],       
                   [candidatename],       
                   [typename]       
            FROM   (SELECT [registrationnumber] [referenceno],       
                     b.[postname],      
          b.[deptname] departmentdivision,      
                           a.[firstname]+' '+a.[middlename]+' '+a.[lastname] [candidatename],       
                           CASE       
                             WHEN discrolallow = 'Completed' THEN 1       
                             WHEN discrolallow = 'Reschedule' THEN 1       
        WHEN discrolallow = 'Yes' THEN 10      
                             ELSE discrolallow       
                           END discrolallow,       
                           CASE       
                             WHEN conflictallow = 'Completed' THEN 2       
                             WHEN conflictallow = 'Reschedule' THEN 2       
        WHEN conflictallow = 'Yes' THEN 10      
                             ELSE conflictallow       
                           END conflictallow,       
                           CASE       
                             WHEN iqallow = 'Completed' THEN 3       
                             WHEN iqallow = 'Reschedule' THEN 3       
        WHEN iqallow = 'Yes' THEN 10      
                             ELSE iqallow       
                           END iqallow,       
                           CASE       
                             WHEN eqallow = 'Completed' THEN 4       
                             WHEN eqallow = 'Reschedule' THEN 4       
        WHEN eqallow = 'Yes' THEN 10      
                             ELSE eqallow       
                           END eqallow       
                    FROM   [dbo].[trecruitcanbasicdtls] a,[dbo].[vw_apppost] b,[dbo].[trecruitcandidatesignup] c      
      
                    WHERE        
                                 
                             eqallow IN ( 'Completed', 'Reschedule' )       
                                  
       and a.candidateid=c.candidateid      
       and c.username=b.username) a,       
                   [dbo].[trecuitpsycycotesttype] b       
            WHERE  a.conflictallow= Cast(b.[id] AS VARCHAR)       
                   AND b.id = @phytypeid       
       and a.postname = @postname    
                   AND a.departmentdivision = @deptname      
        END       
      
      IF @action = 'Selecttypewiseotcandidate'       
        BEGIN       
            SELECT [referenceno],       
                   [candidatename],       
                   [typename]       
            FROM   (SELECT             [registrationnumber][referenceno],       
                           a.[firstname]+' '+a.[middlename]+' '+a.[lastname] [candidatename],       
                           CASE       
                             WHEN discrolallow = 'Completed' THEN 1       
                             WHEN discrolallow = 'Reschedule' THEN 1       
        WHEN discrolallow = 'Yes' THEN 10      
                             ELSE discrolallow       
                           END discrolallow,       
                           CASE       
                             WHEN conflictallow = 'Completed' THEN 2       
                             WHEN conflictallow = 'Reschedule' THEN 2       
        WHEN conflictallow = 'Yes' THEN 10      
                             ELSE conflictallow       
                           END conflictallow,       
                           CASE       
                             WHEN iqallow = 'Completed' THEN 3       
                             WHEN iqallow = 'Reschedule' THEN 3       
        WHEN iqallow = 'Yes' THEN 10      
                             ELSE iqallow       
                           END iqallow,       
                           CASE       
                             WHEN eqallow = 'Completed' THEN 4       
                             WHEN eqallow = 'Reschedule' THEN 4       
        WHEN eqallow = 'Yes' THEN 10      
                             ELSE eqallow       
                           END eqallow       
                    FROM   [dbo].[trecruitcanbasicdtls] a,[dbo].[trecruitotherpost] b      
                    WHERE   discrolallow IN ( 'Completed', 'Reschedule' )       
                                  
       and a.candidateid=b.candidateid) a,       
                   [dbo].[trecuitpsycycotesttype] b       
            WHERE  a.discrolallow = Cast(b.[id] AS VARCHAR)       
                   AND b.id = @phytypeid       
      
       union      
      
       SELECT [referenceno],       
                   [candidatename],       
                   [typename]       
            FROM   (SELECT             [registrationnumber][referenceno],       
                           a.[firstname]+' '+a.[middlename]+' '+a.[lastname] [candidatename],       
                           CASE       
                             WHEN discrolallow = 'Completed' THEN 1       
                             WHEN discrolallow = 'Reschedule' THEN 1       
        WHEN discrolallow = 'Yes' THEN 10      
                             ELSE discrolallow       
                           END discrolallow,       
                           CASE       
                             WHEN conflictallow = 'Completed' THEN 2       
                             WHEN conflictallow = 'Reschedule' THEN 2       
        WHEN conflictallow = 'Yes' THEN 10      
                             ELSE conflictallow       
                           END conflictallow,       
                           CASE       
                             WHEN iqallow = 'Completed' THEN 3       
                             WHEN iqallow = 'Reschedule' THEN 3       
        WHEN iqallow = 'Yes' THEN 10      
                             ELSE iqallow       
                           END iqallow,       
                           CASE       
                             WHEN eqallow = 'Completed' THEN 4       
                             WHEN eqallow = 'Reschedule' THEN 4       
        WHEN eqallow = 'Yes' THEN 10      
                             ELSE eqallow       
                           END eqallow       
                    FROM   [dbo].[trecruitcanbasicdtls] a,[dbo].[trecruitotherpost] b      
                    WHERE    conflictallow IN ( 'Completed', 'Reschedule' )       
                          
       and a.candidateid=b.candidateid) a,       
                   [dbo].[trecuitpsycycotesttype] b       
            WHERE  a.conflictallow = Cast(b.[id] AS VARCHAR)       
                   AND b.id = @phytypeid       
      
        union      
      
       SELECT [referenceno],       
                   [candidatename],       
                   [typename]       
            FROM   (SELECT             [registrationnumber][referenceno],       
                           a.[firstname]+' '+a.[middlename]+' '+a.[lastname] [candidatename],       
                           CASE       
                             WHEN discrolallow = 'Completed' THEN 1       
                             WHEN discrolallow = 'Reschedule' THEN 1       
        WHEN discrolallow = 'Yes' THEN 10      
                             ELSE discrolallow       
                           END discrolallow,       
                           CASE       
                             WHEN conflictallow = 'Completed' THEN 2       
                             WHEN conflictallow = 'Reschedule' THEN 2       
        WHEN conflictallow = 'Yes' THEN 10      
                             ELSE conflictallow       
                           END conflictallow,       
                           CASE       
                             WHEN iqallow = 'Completed' THEN 3       
                             WHEN iqallow = 'Reschedule' THEN 3       
        WHEN iqallow = 'Yes' THEN 10      
                             ELSE iqallow       
                           END iqallow,       
                           CASE       
                             WHEN eqallow = 'Completed' THEN 4       
                             WHEN eqallow = 'Reschedule' THEN 4       
        WHEN eqallow = 'Yes' THEN 10      
                             ELSE eqallow       
                           END eqallow       
                    FROM   [dbo].[trecruitcanbasicdtls] a,[dbo].[trecruitotherpost] b      
                    WHERE    eqallow IN ( 'Completed', 'Reschedule' )       
                                  
       and a.candidateid=b.candidateid) a,       
                   [dbo].[trecuitpsycycotesttype] b       
            WHERE  a.conflictallow = Cast(b.[id] AS VARCHAR)       
                   AND b.id = @phytypeid       
        END       
      
            
      
      IF @action = 'Reschedule'       
        BEGIN       
            --SELECT @candiscrolallow = [discrolallow]       
            --FROM   [dbo].[trecruittraker]       
            --WHERE  [candidateid] = @candidateid       
            --GROUP  BY [discrolallow],       
            --          [conflictallow],       
            --          [iqallow],       
            --          [eqallow]       
      
   SELECT @eqallow = [eqallow]       
            FROM   [dbo].[trecruitcanbasicdtls]      
            WHERE  [candidateid] = @candidateid       
            GROUP  BY [discrolallow],       
                      [conflictallow],       
                      [iqallow],       
                      [eqallow]       
      
                   
            IF @eqallow = 'Completed'       
              BEGIN       
                  UPDATE [dbo].[trecruitcanbasicdtls]       
                  SET    [eqallow] = 'Reschedule'       
                  WHERE  [candidateid] = @candidateid       
              END       
            ELSE       
              BEGIN       
                  SET @message=1       
              END       
        END       
      
      IF @action = 'SELECTEXAMNO'       
        BEGIN       
            SELECT [attemexam],       
                   CASE       
                     WHEN [attemexam] = 1 THEN Cast('1st Exam' AS VARCHAR)       
                     WHEN [attemexam] = 2 THEN Cast('2nd Exam'AS VARCHAR)       
                     WHEN [attemexam] = 3 THEN Cast('3rd Exam'AS VARCHAR)       
                     ELSE Cast([attemexam]AS VARCHAR) + '' + 'th Exam'       
                   END [attemexamtext]       
            FROM   [dbo].[trecruiteqexamdtls]       
            WHERE  candidateid = @candidateid       
                   AND finalsubmit = 'Yes'       
            ORDER  BY [attemexam]       
        END       
      
      IF @action = 'Selecttypewisetotalno'       
        BEGIN       
            SELECT c.[disquestype],       
                   a.questionid,       
                   a.answer,       
                   totscore       
            FROM   [dbo].[trecruitdiscrolcandidatedtls] a,       
                   [dbo].[trecruitdiscrolqusdtls] b,       
                   [dbo].[trecruitdiscrolquestype] c,       
                   [dbo].[trecruitdiscrolansdtls]f,       
                   [dbo].[trecruitcanbasicdtls] d,       
                   [dbo].[languages]e,       
                   (SELECT c.[disquestype],       
                           Sum (a.answer)totscore       
                    FROM   [dbo].[trecruitdiscrolcandidatedtls] a,       
                           [dbo].[trecruitdiscrolqusdtls] b,       
                           [dbo].[trecruitdiscrolquestype] c,       
                           [dbo].[trecruitdiscrolansdtls]f,       
                           [dbo].[trecruitcanbasicdtls] d,       
                           [dbo].[languages]e       
                    WHERE  a.[languageid] = b.[languageid]       
                           AND a.[questionid] = b.[quesserialno]       
                           AND b.[disquestypeid] = c.[id]       
                           AND a.[candidateid] = d.[candidateid]       
                           AND a.[languageid] = e.[id]       
                            AND a.answer = f.[number]      
         and a.[languageid]=f.[languageid]         
                           AND a.candidateid = @candidateid       
                           AND [candidateattemexam] = @candidateattemexam       
                    GROUP  BY c.[disquestype]) z       
            WHERE  a.[languageid] = b.[languageid]       
                   AND a.[questionid] = b.[quesserialno]       
                   AND b.[disquestypeid] = c.[id]       
                   AND a.[candidateid] = d.[candidateid]       
                   AND a.[languageid] = e.[id]       
                    AND a.answer = f.[number]      
     and a.[languageid]=f.[languageid]         
                   AND a.candidateid = @candidateid       
                   AND [candidateattemexam] = @candidateattemexam       
                   AND c.[disquestype] = z.[disquestype]       
            ORDER  BY [disquestype]       
        END       
      
      IF @action = 'Discrolgraph'       
        BEGIN       
            SELECT ( d.totscore * 1.363636 ) TIGERfinalscore,       
                   ( a.totscore * 2 )        CHAMELEONfinalscore,       
                   ( e.totscore * 2.1428 )   TURTLEfinalscore,       
                   ( b.totscore * 1.363636 ) EAGLEfinalscore,       
                   ( a.totscore * 2 )        SALMONfinalscore       
            FROM   (SELECT c.[disquestype],       
                           a.candidateid,       
                           Sum (a.answer)totscore       
                    FROM   [dbo].[trecruitdiscrolcandidatedtls] a,       
                           [dbo].[trecruitdiscrolqusdtls] b,       
                           [dbo].[trecruitdiscrolquestype] c,       
                           [dbo].[trecruitdiscrolansdtls]f,       
                           [dbo].[trecruitcanbasicdtls] d,       
                           [dbo].[languages]e       
                    WHERE  a.[languageid] = b.[languageid]       
                           AND a.[questionid] = b.[quesserialno]       
                           AND b.[disquestypeid] = c.[id]       
                           AND a.[candidateid] = d.[candidateid]       
                           AND a.[languageid] = e.[id]       
                            AND a.answer = f.[number]      
         and a.[languageid]=f.[languageid]          
                           AND a.candidateid = @candidateid       
                           AND [candidateattemexam] = @candidateattemexam       
                           AND c.[disquestype] = 'CHAMELEON'       
                    GROUP  BY c.[disquestype],       
                              a.candidateid) a,       
                   (SELECT c.[disquestype],       
                           a.candidateid,       
                           Sum (a.answer)totscore       
                    FROM   [dbo].[trecruitdiscrolcandidatedtls] a,       
                           [dbo].[trecruitdiscrolqusdtls] b,       
                           [dbo].[trecruitdiscrolquestype] c,       
                           [dbo].[trecruitdiscrolansdtls]f,       
                           [dbo].[trecruitcanbasicdtls] d,       
                           [dbo].[languages]e       
                    WHERE  a.[languageid] = b.[languageid]       
                           AND a.[questionid] = b.[quesserialno]       
                           AND b.[disquestypeid] = c.[id]       
                           AND a.[candidateid] = d.[candidateid]       
                           AND a.[languageid] = e.[id]       
                            AND a.answer = f.[number]      
         and a.[languageid]=f.[languageid]         
                           AND a.candidateid = @candidateid       
                           AND [candidateattemexam] = @candidateattemexam       
                           AND c.[disquestype] = 'EAGLE'       
                    GROUP  BY c.[disquestype],       
                              a.candidateid) b,       
                   (SELECT c.[disquestype],       
                           a.candidateid,       
                           Sum (a.answer)totscore       
                    FROM   [dbo].[trecruitdiscrolcandidatedtls] a,       
                           [dbo].[trecruitdiscrolqusdtls] b,       
                           [dbo].[trecruitdiscrolquestype] c,       
                           [dbo].[trecruitdiscrolansdtls]f,       
                           [dbo].[trecruitcanbasicdtls] d,       
                           [dbo].[languages]e       
                    WHERE  a.[languageid] = b.[languageid]       
                           AND a.[questionid] = b.[quesserialno]       
                           AND b.[disquestypeid] = c.[id]       
                           AND a.[candidateid] = d.[candidateid]       
                           AND a.[languageid] = e.[id]       
                            AND a.answer = f.[number]      
         and a.[languageid]=f.[languageid]         
                           AND a.candidateid = @candidateid       
                           AND [candidateattemexam] = @candidateattemexam       
                           AND c.[disquestype] = 'SALMON'       
                    GROUP  BY c.[disquestype],       
                              a.candidateid) c,       
                   (SELECT c.[disquestype],       
                           a.candidateid,       
                           Sum (a.answer)totscore       
                    FROM   [dbo].[trecruitdiscrolcandidatedtls] a,       
                           [dbo].[trecruitdiscrolqusdtls] b,       
                           [dbo].[trecruitdiscrolquestype] c,       
                           [dbo].[trecruitdiscrolansdtls]f,       
                           [dbo].[trecruitcanbasicdtls] d,       
                           [dbo].[languages]e       
                    WHERE  a.[languageid] = b.[languageid]       
                           AND a.[questionid] = b.[quesserialno]       
                           AND b.[disquestypeid] = c.[id]       
                           AND a.[candidateid] = d.[candidateid]       
                           AND a.[languageid] = e.[id]       
                            AND a.answer = f.[number]      
         and a.[languageid]=f.[languageid]         
                           AND a.candidateid = @candidateid       
                           AND [candidateattemexam] = @candidateattemexam       
                           AND c.[disquestype] = 'TIGER'       
                    GROUP  BY c.[disquestype],       
                              a.candidateid) d,       
                   (SELECT c.[disquestype],       
                           a.candidateid,       
                           Sum (a.answer)totscore       
                    FROM   [dbo].[trecruitdiscrolcandidatedtls] a,       
                           [dbo].[trecruitdiscrolqusdtls] b,       
                           [dbo].[trecruitdiscrolquestype] c,       
                           [dbo].[trecruitdiscrolansdtls]f,       
                           [dbo].[trecruitcanbasicdtls] d,       
                           [dbo].[languages]e       
                    WHERE  a.[languageid] = b.[languageid]       
                           AND a.[questionid] = b.[quesserialno]       
                           AND b.[disquestypeid] = c.[id]       
                      AND a.[candidateid] = d.[candidateid]       
                           AND a.[languageid] = e.[id]       
                            AND a.answer = f.[number]      
         and a.[languageid]=f.[languageid]         
                           AND a.candidateid = @candidateid       
                           AND [candidateattemexam] = @candidateattemexam       
                           AND c.[disquestype] = 'TURTLE'       
                    GROUP  BY c.[disquestype],       
                              a.candidateid) e       
            WHERE  a.candidateid = b.candidateid       
                   AND a.candidateid = c.candidateid       
                   AND a.candidateid = d.candidateid       
                   AND a.candidateid = e.candidateid       
        END       
      
      IF @action = 'Activeinactiveresbutton'       
        BEGIN
		
            SELECT       
                   a.firstname+' '+a.middlename+' '+a.lastname empname,      
       b.position,Isnull (a.[eqallow],'') eqallow       
         FROM   [dbo].[trecruitcanbasicdtls] a  ,[vw_canapppost] b                    
            WHERE   a.candidateid = @candidateid     
   and a.candidateid=b.candidateid     
    
        END       
    
 IF @action = 'Comment'       
        BEGIN       
           Select B.Comment     
   From trecruitcanbasicdtls A        
  Inner Join trecruiteqexamdtls B        
  On A.candidateid = B.candidateid        
  Where A.registrationnumber =@registrationnumber     
  And B.attemexam = @candidateattemexam    
      
        END       
      
       
      
  if @action='EQreport'      
  begin      
      
        
      
SELECT 'SENSITIVITY (Range of score: 25-100)'                 eqdimention,       
       '2-8-16-17-22 (5 Situations)' Situations,       
       candidatescore,       
       Candidatepercentile ,      
    case WHEN Candidatepercentile ='P-90' then 'Extremely high EQ'      
         WHEN Candidatepercentile='P-75' then 'High EQ'      
         WHEN Candidatepercentile ='P-50' then 'Moderate EQ'      
         WHEN Candidatepercentile ='P-40' then 'Low Eq'      
         WHEN Candidatepercentile = 'P-20' then 'Try the test again some other day'      
         ELSE Candidatepercentile       
       END                           Interpretation      
FROM      
      
      
(SELECT 'SENSITIVITY (Range of score: 25-100)'                 Sensitivity,       
       '2-8-16-17-22 (5 Situations)' Situations,       
       candidatescore,       
       CASE       
         WHEN Cast (candidatescore AS VARCHAR) BETWEEN 93 AND 100 THEN 'P-90'       
         WHEN Cast (candidatescore AS VARCHAR) BETWEEN 86 AND 92 THEN 'P-75'       
         WHEN Cast (candidatescore AS VARCHAR) BETWEEN 66 AND 85 THEN 'P-50'       
         WHEN Cast (candidatescore AS VARCHAR) BETWEEN 36 AND 65 THEN 'P-40'       
         WHEN Cast (candidatescore AS VARCHAR) < 35 THEN 'P-20'       
         ELSE Cast (candidatescore AS VARCHAR)       
       END                           Candidatepercentile       
FROM   (SELECT Sum(MARK.[marks]) Candidatescore       
        FROM   [dbo].[trecruiteqcandidatedtls] ANS,       
               [dbo].[trecruiteqansmarks] MARK       
        WHERE  ANS.[questionid] IN ( 2, 8, 16, 17, 22 )       
               AND ans.candidateid = @candidateid       
               AND ANS.[answer] = MARK.[answerno]       
               AND ANS.[questionid] = MARK.[questionno]      
      and [candidateattemexam]=@candidateattemexam) a )a      
      
      union      
      
SELECT 'MATURITY (Range of score: 35-140)'                 Sensitivity,       
       '4-6-9-11-12-18-21 (7 Situations)' Situations,       
       candidatescore,       
       Candidatepercentile,      
     case WHEN Candidatepercentile ='P-90' then 'Extremely high EQ'      
         WHEN Candidatepercentile='P-75' then 'High EQ'      
         WHEN Candidatepercentile ='P-50' then 'Moderate EQ'      
         WHEN Candidatepercentile ='P-40' then 'Low Eq'      
         WHEN Candidatepercentile = 'P-20' then 'Try the test again some other day'      
         ELSE Candidatepercentile       
       END                           Interpretation       
      
from(SELECT 'MATURITY (Range of score: 35-140)'                 Sensitivity,       
       '4-6-9-11-12-18-21 (7 Situations)' Situations,       
       candidatescore,       
       CASE       
         WHEN Cast (candidatescore AS VARCHAR) BETWEEN 133 AND 140 THEN 'P-90'       
         WHEN Cast (candidatescore AS VARCHAR) BETWEEN 113 AND 132 THEN 'P-75'       
         WHEN Cast (candidatescore AS VARCHAR) BETWEEN 88 AND 112 THEN 'P-50'       
         WHEN Cast (candidatescore AS VARCHAR) BETWEEN 53 AND 87 THEN 'P-40'       
         WHEN Cast (candidatescore AS VARCHAR) < 52 THEN 'P-20'       
         ELSE Cast (candidatescore AS VARCHAR)       
       END                           Candidatepercentile       
FROM   (SELECT Sum(MARK.[marks]) Candidatescore       
        FROM   [dbo].[trecruiteqcandidatedtls] ANS,       
               [dbo].[trecruiteqansmarks] MARK       
        WHERE  ANS.[questionid] IN ( 4,6,9,11,12,18,21 )       
               AND ans.candidateid = @candidateid       
               AND ANS.[answer] = MARK.[answerno]       
               AND ANS.[questionid] = MARK.[questionno]      
      and [candidateattemexam]=@candidateattemexam) a )a      
      
      union      
      
SELECT 'COMPETENCY (Range of score: 50-200)'                 Sensitivity,       
       '1-3-5-7-10-13-14-15-19-20 (10 Situations)' Situations,       
       candidatescore,       
       Candidatepercentile,       
    case WHEN Candidatepercentile ='P-90' then 'Extremely high EQ'      
         WHEN Candidatepercentile='P-75' then 'High EQ'      
   WHEN Candidatepercentile ='P-50' then 'Moderate EQ'      
         WHEN Candidatepercentile ='P-40' then 'Low Eq'      
         WHEN Candidatepercentile = 'P-20' then 'Try the test again some other day'      
         ELSE Candidatepercentile       
       END                           Interpretation      
from(SELECT 'COMPETENCY (Range of score: 50-200)'                 Sensitivity,       
       '1-3-5-7-10-13-14-15-19-20 (10 Situations)' Situations,       
       candidatescore,       
       CASE       
         WHEN Cast (candidatescore AS VARCHAR) BETWEEN 168 AND 200 THEN 'P-90'       
         WHEN Cast (candidatescore AS VARCHAR) BETWEEN 141 AND 167 THEN 'P-75'       
         WHEN Cast (candidatescore AS VARCHAR) BETWEEN 97 AND 140 THEN 'P-50'       
         WHEN Cast (candidatescore AS VARCHAR) BETWEEN 71 AND 96 THEN 'P-40'       
         WHEN Cast (candidatescore AS VARCHAR) < 70 THEN 'P-20'       
         ELSE Cast (candidatescore AS VARCHAR)       
       END                           Candidatepercentile       
FROM   (SELECT Sum(MARK.[marks]) Candidatescore       
        FROM   [dbo].[trecruiteqcandidatedtls] ANS,       
               [dbo].[trecruiteqansmarks] MARK       
        WHERE  ANS.[questionid] IN ( 1,3,5,7,10,13,14,15,19,20 )       
               AND ans.candidateid = @candidateid       
               AND ANS.[answer] = MARK.[answerno]       
   AND ANS.[questionid] = MARK.[questionno]      
      and [candidateattemexam]=@candidateattemexam) a )a      
      
      union      
      
             
select 'TOTAL EQ SCORE (Range of score: 110-440)' Sensitivity,'All Situations (22 situations)' Situations,candidatescore,       
 Candidatepercentile ,      
 case WHEN Candidatepercentile ='P-90' then 'Extremely high EQ'      
         WHEN Candidatepercentile='P-75' then 'High EQ'      
         WHEN Candidatepercentile ='P-50' then 'Moderate EQ'      
         WHEN Candidatepercentile ='P-40' then 'Low Eq'      
         WHEN Candidatepercentile = 'P-20' then 'Try the test again some other day'      
         ELSE Candidatepercentile       
       END                           Interpretation      
       
 from       
 (select 'TOTAL EQ SCORE (Range of score: 110-440)' Sensitivity,'All Situations (22 situations)' Situations,candidatescore,      
CASE       
         WHEN Cast (candidatescore AS VARCHAR) BETWEEN 379 AND 400 THEN 'P-90'       
         WHEN Cast (candidatescore AS VARCHAR) BETWEEN 308 AND 378 THEN 'P-75'       
         WHEN Cast (candidatescore AS VARCHAR) BETWEEN 261 AND 307 THEN 'P-50'       
         WHEN Cast (candidatescore AS VARCHAR) BETWEEN 159 AND 260 THEN 'P-40'       
         WHEN Cast (candidatescore AS VARCHAR) < 158 THEN 'P-20'       
         ELSE Cast (candidatescore AS VARCHAR)       
       END                           Candidatepercentile       
      
from (select sum(candidatescore) candidatescore      
      
from (SELECT 'SENSITIVITY'                 Sensitivity,       
       '2-8-16-17-22 (5 Situations)' Situations,       
       candidatescore,       
       CASE       
         WHEN Cast (candidatescore AS VARCHAR) BETWEEN 93 AND 100 THEN 'P-90'       
         WHEN Cast (candidatescore AS VARCHAR) BETWEEN 86 AND 92 THEN 'P-75'       
         WHEN Cast (candidatescore AS VARCHAR) BETWEEN 66 AND 85 THEN 'P-50'       
         WHEN Cast (candidatescore AS VARCHAR) BETWEEN 36 AND 65 THEN 'P-40'       
         WHEN Cast (candidatescore AS VARCHAR) < 35 THEN 'P-20'       
         ELSE Cast (candidatescore AS VARCHAR)       
       END                           Candidatepercentile       
FROM   (SELECT Sum(MARK.[marks]) Candidatescore       
        FROM   [dbo].[trecruiteqcandidatedtls] ANS,       
               [dbo].[trecruiteqansmarks] MARK       
        WHERE  ANS.[questionid] IN ( 2, 8, 16, 17, 22 )       
               AND ans.candidateid = @candidateid       
               AND ANS.[answer] = MARK.[answerno]       
               AND ANS.[questionid] = MARK.[questionno]      
      and [candidateattemexam]=@candidateattemexam) a       
      
      union      
      
SELECT 'MATURITY'                 Sensitivity,       
       '4-6-9-11-12-18-21 (7 Situations)' Situations,       
       candidatescore,       
       CASE       
         WHEN Cast (candidatescore AS VARCHAR) BETWEEN 133 AND 140 THEN 'P-90'       
        WHEN Cast (candidatescore AS VARCHAR) BETWEEN 113 AND 132 THEN 'P-75'       
         WHEN Cast (candidatescore AS VARCHAR) BETWEEN 88 AND 112 THEN 'P-50'       
         WHEN Cast (candidatescore AS VARCHAR) BETWEEN 53 AND 87 THEN 'P-40'       
         WHEN Cast (candidatescore AS VARCHAR) < 52 THEN 'P-20'       
         ELSE Cast (candidatescore AS VARCHAR)       
       END                           Candidatepercentile       
FROM   (SELECT Sum(MARK.[marks]) Candidatescore       
        FROM   [dbo].[trecruiteqcandidatedtls] ANS,       
               [dbo].[trecruiteqansmarks] MARK       
        WHERE  ANS.[questionid] IN ( 4,6,9,11,12,18,21 )       
               AND ans.candidateid = @candidateid       
               AND ANS.[answer] = MARK.[answerno]       
               AND ANS.[questionid] = MARK.[questionno]      
      and [candidateattemexam]=@candidateattemexam) a       
      
      union      
      
SELECT 'COMPETENCY'                 Sensitivity,       
       '1-3-5-7-10-13-14-15-19-20 (10 Situations)' Situations,       
       candidatescore,       
       CASE       
         WHEN Cast (candidatescore AS VARCHAR) BETWEEN 168 AND 200 THEN 'P-90'       
         WHEN Cast (candidatescore AS VARCHAR) BETWEEN 141 AND 167 THEN 'P-75'       
         WHEN Cast (candidatescore AS VARCHAR) BETWEEN 97 AND 140 THEN 'P-50'       
         WHEN Cast (candidatescore AS VARCHAR) BETWEEN 71 AND 96 THEN 'P-40'       
         WHEN Cast (candidatescore AS VARCHAR) < 70 THEN 'P-20'       
         ELSE Cast (candidatescore AS VARCHAR)       
       END                           Candidatepercentile       
FROM   (SELECT Sum(MARK.[marks]) Candidatescore       
        FROM   [dbo].[trecruiteqcandidatedtls] ANS,       
               [dbo].[trecruiteqansmarks] MARK       
        WHERE  ANS.[questionid] IN ( 1,3,5,7,10,13,14,15,19,20 )       
               AND ans.candidateid = @candidateid       
               AND ANS.[answer] = MARK.[answerno]       
               AND ANS.[questionid] = MARK.[questionno]      
      and [candidateattemexam]=@candidateattemexam) a )a)a)a      
  end      
  END 
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: Languages, tempPsychometricTestMapping, trecruitcanbasicdtls, trecruitcandidatesignup, trecruiteqansmarks, trecruiteqcandidatedtls, trecruiteqcanlanguagemap, trecruiteqexamdtls, trecruiteqquesdtls, trecruiteqrandomques */
/****** Object:  StoredProcedure [dbo].[proceqmasdtls]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[proceqmasdtls]      @action           NVARCHAR(100)=NULL, 
                                      @conquestype      NVARCHAR(100)=NULL, 
                                      @username         NVARCHAR(100)=NULL, 
                                      @activeflag       NVARCHAR(10)=NULL, 
                                      @conquestypeid    INT=NULL, 
                                      @languageid       INT=NULL, 
                                      @question         NVARCHAR(max)=NULL, 
                                      @questiondtlsid   INT=NULL, 
                                      @answer           NVARCHAR(max)=NULL, 
                                      @number           INT=NULL, 
                                      @answerdtlsid     INT=NULL, 
                                      @quesserialnonext INT=NULL, 
                                      @ollanguageid     INT=NULL, 
                                      @olquesserialno   INT=NULL, 
                                      @message          VARCHAR(500)=NULL output 
AS 
    DECLARE @empcode VARCHAR(100) 
    DECLARE @candidateid INT 
    DECLARE @anslanguageid INT 
    DECLARE @queslanguageid INT 
    DECLARE @countexamques INT 
    DECLARE @countexamattm INT 
    DECLARE @countexamattques INT 
    DECLARE @quesserialno INT 
    DECLARE @maplanid INT 
    DECLARE @countexamattmcan INT 
    DECLARE @findques INT 
    DECLARE @idd INT 
    DECLARE @attemptno INT 
    DECLARE @cattemptno INT 
    DECLARE @atteptestno INT 
	DECLARE @quesset INT 
    DECLARE @aquesset INT 
    DECLARE @createdtime DATETIME 
    DECLARE @cancreatedtime DATETIME 
    DECLARE @orquesserialno INT 
    DECLARE @canquesset INT 
	DECLARE @sRanquesserialno int
	declare @empno int								 ---ishita


  BEGIN 

      set @languageid=5
	  set @maplanid=5
      SELECT @empcode = empcode 
      FROM   essp.dbo.emp 
      WHERE  empemail = @username 



	  SELECT @empno = empno 
      FROM   [essp].[dbo].[Empbasic]			------ishita
      WHERE  [empemail] = @username 
	  and empstatus='ACTIVE'



      SELECT @candidateid = candidateid 
      FROM   [Recruitment].[dbo].[trecruitcandidatesignup] 
      WHERE  [username] = @username 

      --SELECT @maplanid = languageid 
      --FROM   [Recruitment].[dbo].[trecruiteqcanlanguagemap] p 
      --WHERE  candidateid = @candidateid 

	  --SELECT @createdtime = Max([createddate]) 
   --   FROM   [Recruitment].[dbo].[trecruiteqrandomques] p 
   --   WHERE  languageid = @maplanid 

	  SELECT @cancreatedtime = Max([createddate]) 
      FROM   [Recruitment].[dbo].[trecruiteqrandomques] p 
     

      --SELECT @quesset = quesset 
      --FROM   [Recruitment].[dbo].[trecruiteqrandomques] p 
      --WHERE  languageid = @maplanid 
      --       AND createddate = @createdtime 

      SELECT @canquesset = quesset 
      FROM   [Recruitment].[dbo].[trecruiteqrandomques] p 
      WHERE   createddate = @cancreatedtime 
            

      IF @canquesset = 1 
        BEGIN 
            SET @aquesset=@canquesset + 1 
        END 
      ELSE IF @canquesset = 2 
       BEGIN 
            SET @aquesset=@canquesset + 1 
      END 
      ELSE IF @canquesset = 3 
       BEGIN 
           SET @aquesset=@canquesset-2 
       END 


      SELECT @countexamques = Count([question]) 
      FROM   [Recruitment].[dbo].[trecruiteqquesdtls]
      WHERE  [languageid] = 5 
	  AND [queslanset] = @canquesset 

	  SELECT @countexamattm = [attemexam] 
            FROM   [Recruitment].[dbo].[trecruiteqexamdtls] 
            WHERE  [candidateid] = @candidateid 
                   AND finalsubmit <> 'Yes' 

      SELECT @quesserialno = Min([ranquesserialno]) 
      FROM   [Recruitment].[dbo].[trecruiteqquesdtls] p 
      WHERE  languageid = 5            
			  AND [queslanset] = @canquesset 


     SELECT @orquesserialno = [quesserialno] 
      FROM   [Recruitment].[dbo].[trecruiteqquesdtls] ans 
      WHERE  [queslanset] = @canquesset 
             AND [ranquesserialno] = @questiondtlsid 

      SELECT @findques = Count(questionid) 
      FROM   [Recruitment].[dbo].[trecruiteqcandidatedtls] 
      WHERE  candidateid = @candidateid 
             AND questionid = @orquesserialno 
             AND [quesfinalsubmitques] IS NULL 


      IF @action = 'EQcandidatelanguagemap' 
        BEGIN 
            DELETE FROM [dbo].[trecruiteqcanlanguagemap]
            WHERE  [candidateid] = @candidateid 

            INSERT INTO [dbo].[trecruiteqcanlanguagemap] 
                        ([candidateid], 
                         [languageid]) 
            VALUES      (@candidateid, 
                         5) 
						  INSERT INTO [dbo].[trecruiteqrandomques] 
                        ([languageid], 
                         [quesset], 
                         [createddate], 
                         candidateid) 
            VALUES      (@languageid, 
                         @aquesset, 
                         Getdate(), 
                         @candidateid ) 

						 SELECT @maplanid = languageid 
            FROM   [Recruitment].[dbo].[trecruiteqcanlanguagemap] p 
            WHERE  candidateid = @candidateid 

      SELECT @countexamques = Count([question]) 
      FROM   [Recruitment].[dbo].[trecruiteqquesdtls] 
       WHERE  [languageid] = @maplanid 
        AND [queslanset] = @canquesset 

		

            SELECT @attemptno = Count([attemexam]) 
            FROM   [Recruitment].[dbo].[trecruiteqexamdtls] 
            WHERE  [finalsubmit] = 'Yes' 
                   AND candidateid = @candidateid 

            DELETE FROM [Recruitment].[dbo].[trecruiteqcandidatedtls] 
            WHERE  [quesfinalsubmitques] IS NULL 
                   AND candidateid = @candidateid 

            DELETE FROM [Recruitment].[dbo].[trecruiteqexamdtls] 
            WHERE  [finalsubmit] = 'No' 
                   AND candidateid = @candidateid 

            INSERT INTO [Recruitment].[dbo].[trecruiteqexamdtls] 
                        ([candidateid], 
                         [languageid], 
                         [totalques], 
                         [attemques], 
                         [finalsubmit], 
                         [attemexam]) 
            VALUES      ( @candidateid, 
                          5, 
                          @countexamques, 
                          null, 
                          'No', 
                          @attemptno + 1 ) 
        END 

      IF @action = 'EQquesansselect' 
        BEGIN 

		 SELECT @orquesserialno=[quesserialno]      
  FROM [Recruitment].[dbo].[trecruiteqquesdtls]
  where [Queslanset]=@canquesset and [Ranquesserialno]=@quesserialno


             SELECT previousvalue,                   
                   ranquesserialno quesserialno, 
                   question, 
                   nextvalue,                    
                   noofques ,
				   quescount noofoption
            FROM   (SELECT Lag(p.ranquesserialno) 
                             OVER ( 
                               ORDER BY p.[ranquesserialno]) PreviousValue, 
                           Lag(p.question) 
                             OVER ( 
                               ORDER BY p.[ranquesserialno]) PreviousValueques, 
                           p.ranquesserialno, 
                           p.question, 
						   p.[quesserialno],
                           Lead(p.ranquesserialno) 
                             OVER ( 
                               ORDER BY p.[ranquesserialno]) NextValue, 
                           Lead(p.question) 
                             OVER ( 
                               ORDER BY p.[ranquesserialno]) NextValueques, 
                           languageid 
                    FROM   [Recruitment].[dbo].[trecruiteqquesdtls] p 
       WHERE  languageid = 5                          
                           AND [queslanset] = @canquesset)s, 
                   (SELECT languageid, 
                           Count([quesserialno])noofques 
                    FROM   [Recruitment].[dbo].[trecruiteqquesdtls] 
                    WHERE  languageid = 5                            
                           AND [queslanset] = @canquesset
                    GROUP  BY languageid) p ,(SELECT questionno,count([answerno])quescount
      
                 FROM [Recruitment].[dbo].[trecruiteqansmarks]
                             where questionno=@orquesserialno 
                              group by questionno)w
            WHERE  ranquesserialno = @quesserialno 
                   AND p.languageid = s.languageid 
        END 

      IF @action = 'EQquesansselectnext' 
        BEGIN 
             SELECT @orquesserialno=[quesserialno]
      
  FROM [Recruitment].[dbo].[trecruiteqquesdtls]
  where [Queslanset]=@canquesset and [Ranquesserialno]=@quesserialnonext

     
            SELECT previousvalue, 
                    
                   ranquesserialno quesserialno, 
                   question, 
                   nextvalue, 
                   
                   noofques, 
				   quescount noofoption,
                   CASE 
                     WHEN x.candidateid IS NULL THEN 0 
                     ELSE x.candidateid 
                   END             candidateid, 
                   CASE 
                     WHEN x.[answer] IS NULL THEN 0 
                     ELSE x.[answer] 
                   END             answer, 
                   CASE 
                     WHEN y.[attemques] BETWEEN 1 AND 100 THEN y.[attemques] 
                     ELSE y.[attemques] 
                   END             [attemques] 
            FROM   (SELECT Lag(p.ranquesserialno) 
                             OVER ( 
                               ORDER BY p.[ranquesserialno]) PreviousValue, 
                           Lag(p.question) 
                             OVER ( 
                               ORDER BY p.[ranquesserialno]) PreviousValueques, 
                           p.ranquesserialno, 
                           p.quesserialno, 
                           p.question, 
                           Lead(p.ranquesserialno) 
                             OVER ( 
                               ORDER BY p.[ranquesserialno]) NextValue, 
                           Lead(p.question) 
                             OVER ( 
                               ORDER BY p.[ranquesserialno]) NextValueques, 
                           languageid 
                    FROM   [Recruitment].[dbo].[trecruiteqquesdtls] p 
                    WHERE  languageid = 5 
                           
                           AND [queslanset] = @canquesset)s 
                   LEFT OUTER JOIN 
                   [Recruitment].[dbo].[trecruiteqcandidatedtls] 
                   x 
                                ON s.languageid = x.[languageid] 
                                   AND s.quesserialno = x.[questionid] 
                                   AND [quesfinalsubmitques] IS NULL 
                                   AND x.[candidateid] = @candidateid, 
                   (SELECT languageid, 
                           count([quesserialno])noofques 
                    FROM   [Recruitment].[dbo].[trecruiteqquesdtls] 
                    WHERE  languageid = 5 
                           
                           AND [queslanset] = @canquesset 
                    GROUP  BY languageid) p, (SELECT questionno,count([answerno])quescount
      
                 FROM [Recruitment].[dbo].[trecruiteqansmarks]
                             where questionno=@orquesserialno
                              group by questionno)w,
                   [Recruitment].[dbo].[trecruiteqexamdtls] y 
            WHERE  ranquesserialno = @quesserialnonext 
                   AND p.languageid = s.languageid 
                   AND s.languageid = y.[languageid] 
                   AND y.[candidateid] = @candidateid 
                   AND [finalsubmit] = 'No' 
        END 

      IF @action = 'EQansselect' 
        BEGIN 

		SELECT @orquesserialno = [quesserialno] 
            FROM   [Recruitment].[dbo].[trecruiteqquesdtls] ans 
            WHERE  [queslanset] = @canquesset 
                   AND [ranquesserialno] = @quesserialnonext 

            SELECT [answerno], 
                   [answer], 
                   language 
            FROM   [Recruitment].[dbo].[trecruiteqansmarks] ans, 
                   [Recruitment].[dbo].[languages] lan,[Recruitment].[dbo].[trecruiteqquesdtls] qus 
            WHERE  ans.[languageid] = lan.[id] 
                   AND lan.[id] = 5
				   and ans.[questionno]=qus.[quesserialno]
				   and qus.[quesserialno]=@orquesserialno
				   and [queslanset] = @canquesset
				   
        END 

      IF @action = 'EQolquesansselect' 
        BEGIN 
         SELECT @orquesserialno = [quesserialno] 
            FROM   [Recruitment].[dbo].[trecruiteqquesdtls] ans 
            WHERE  [queslanset] = @canquesset 
                   AND [ranquesserialno] = @questiondtlsid 

            SELECT [question] 
            FROM   [Recruitment].[dbo].[trecruiteqquesdtls] 
            WHERE  languageid = 5
                   AND ranquesserialno = @olquesserialno 
                   AND [queslanset] = @canquesset 

            SELECT [answerno], 
                   [answer] 
            FROM   [Recruitment].[dbo].[trecruiteqansdtls] ans,
			[Recruitment].[dbo].[trecruiteqquesdtls] qus 
            WHERE  ans.[languageid] = 5
			and ans.[questionno]=qus.[quesserialno]
			and qus.[quesserialno]=@orquesserialno
        END 

		 IF @action = 'EQfirstquesansselect' 
        BEGIN 
        
		 SELECT @orquesserialno=[quesserialno]      
  FROM [Recruitment].[dbo].[trecruiteqquesdtls]
  where [Queslanset]=@canquesset and [Ranquesserialno]=@quesserialno

            SELECT [answerno], 
                   [answer] 
            FROM   [Recruitment].[dbo].trecruiteqansmarks ans, [Recruitment].[dbo].trecruiteqquesdtls  qus 
            WHERE  ans.[languageid] = 5
			and ans.[questionno]=qus.[quesserialno]
			and qus.[quesserialno]=@orquesserialno
			AND [queslanset] = @canquesset 
        END 
     

      IF @action = 'EQcandtlsinsert' 
         AND @findques = 0 
        BEGIN 
            SELECT @countexamattm = [attemexam] 
            FROM   [Recruitment].[dbo].[trecruiteqexamdtls] 
            WHERE  [candidateid] = @candidateid 
                   AND finalsubmit <> 'Yes' 

            SELECT @countexamattmcan = Count([candidateid]) 
            FROM   [Recruitment].[dbo].[trecruiteqexamdtls] 
            WHERE  [candidateid] = @candidateid 

			SELECT @orquesserialno = [quesserialno] 
            FROM   [Recruitment].[dbo].[trecruiteqquesdtls] ans 
            WHERE  [queslanset] = @canquesset 
                   AND [ranquesserialno] = @questiondtlsid 

           BEGIN 
                INSERT INTO [Recruitment].[dbo].[trecruiteqcandidatedtls] 
                            ([candidateid], 
                             exquesset, 
							 [Serialno],
                             [languageid], 
                             [questionid], 
                             [answer], 
                             candidateattemexam, 
                             [createdon], 
                             [updatedon]) 
                VALUES      ( @candidateid, 
                              @canquesset, 
							  @questiondtlsid,
                              @maplanid, 
                              @orquesserialno, 
                              @number, 
                              @countexamattm, 
                              Getdate(), 
           Getdate() ) 

                SET @message='Answer Details Successfully Inserted' 
            END 

            SELECT @countexamattques = Count([questionid]) 
            FROM   [Recruitment].[dbo].[trecruiteqcandidatedtls] 
            WHERE  candidateid = @candidateid 
                   AND answer <> 0 
                   AND quesfinalsubmitques IS NULL 

            IF @countexamattm IS NOT NULL 
              BEGIN 
                  UPDATE [Recruitment].[dbo].[trecruiteqexamdtls] 
                  SET    [attemques] = [totalques] - @countexamattques 
                  WHERE  candidateid = @candidateid 
                         AND finalsubmit = 'No' 
              END 
        END 

      IF @action = 'EQcandtlsinsert' 
         AND @findques > 0 
        BEGIN 
            SELECT @countexamattm = [attemexam] 
            FROM   [Recruitment].[dbo].[trecruiteqexamdtls] 
            WHERE  [candidateid] = @candidateid 
                   AND finalsubmit <> 'Yes' 

           SELECT @orquesserialno = [quesserialno] 
            FROM   [Recruitment].[dbo].[trecruiteqquesdtls] ans 
            WHERE  [queslanset] = @canquesset 
                   AND [ranquesserialno] = @questiondtlsid 

            UPDATE [Recruitment].[dbo].[trecruiteqcandidatedtls] 
            SET    [answer] = @number, 
                   [updatedon] = Getdate() 
            WHERE  [candidateid] = @candidateid 
                   AND [questionid] = @orquesserialno  
                   AND [quesfinalsubmitques] IS NULL 

            SET @message='Answer Details Successfully Updated' 

            SELECT @countexamattques = Count([questionid]) 
            FROM   [Recruitment].[dbo].[trecruiteqcandidatedtls] 
            WHERE  candidateid = @candidateid 
                   AND answer <> 0 
                   AND quesfinalsubmitques IS NULL 

            IF @countexamattm IS NOT NULL 
              BEGIN 
                  UPDATE [Recruitment].[dbo].[trecruiteqexamdtls] 
                  SET    [attemques] = [totalques] - @countexamattques 
                  WHERE  candidateid = @candidateid 
                         AND finalsubmit = 'No' 
              END 
        END 

      IF @action = 'Finalsubmit' 
        BEGIN 
            UPDATE [Recruitment].[dbo].[trecruiteqexamdtls] 
            SET    [finalsubmit] = 'Yes' 
            WHERE  candidateid = @candidateid 

            UPDATE [Recruitment].[dbo].[trecruitcanbasicdtls] 
            SET    [eqallow] = 'Completed' 
            WHERE  candidateid = @candidateid 


			UPDATE [essp].[dbo].[temppsychometrictestmapping] 
            SET    [EQTest] = 'Completed'									------ishita
            WHERE  empno = @empno


            UPDATE [dbo].[trecruiteqcandidatedtls] 
            SET    [quesfinalsubmitques] = 'F' 
            WHERE  candidateid = @candidateid 
        END 

      IF @action = 'Eqansqnoselect' 
        BEGIN 
            SELECT @atteptestno = [attemexam] 
            FROM   [Recruitment].[dbo].[trecruiteqexamdtls] 
            WHERE  [finalsubmit] = 'No'  
                   AND [candidateid] = @candidateid 

            SELECT [Serialno][questionid] 
            FROM   [Recruitment].[dbo].[trecruiteqcandidatedtls] 
            WHERE  [answer] > 0 
                   AND [candidateattemexam] = @atteptestno 
                   AND [candidateid] = @candidateid 
        END 

  END 
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: trecruitcanbasicdtls, trecruitfirobexamdtls, trecruittraker */
/****** Object:  StoredProcedure [dbo].[procfirobhrdtls]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[procfirobhrdtls]
@candidateattemexam INT=NULL, 
@registrationnumber VARCHAR(200)=NULL,
@action varchar(200),
@Message            VARCHAR(200)=NULL 
as
declare @candidateid int
declare @canfiroballow varchar(100)

begin
SELECT @candidateid = candidateid 
      FROM   [dbo].[trecruitcanbasicdtls] 
      WHERE  registrationnumber = @registrationnumber 
IF @action = 'SELECTEXAMNO' 
        BEGIN 
            SELECT [attemexam], 
                   CASE 
                     WHEN [attemexam] = 1 THEN Cast('1st Exam' AS VARCHAR) 
                     WHEN [attemexam] = 2 THEN Cast('2nd Exam'AS VARCHAR) 
                     WHEN [attemexam] = 3 THEN Cast('3rd Exam'AS VARCHAR) 
                     ELSE Cast([attemexam]AS VARCHAR) + '' + 'th Exam' 
                   END [attemexamtext] 
            FROM   [dbo].trecruitfirobexamdtls
            WHERE  candidateid = @candidateid 
                   AND finalsubmit = 'Yes' 
            ORDER  BY [attemexam] 
        END 
IF @action = 'Activeinactiveresbutton' 
        BEGIN 
            SELECT 
                   a.[firoballow] 
            FROM   [dbo].[trecruitcanbasicdtls] a                
            WHERE a.candidateid = @candidateid 
        END 
  IF @action = 'Reschedule' 
        BEGIN 
            --SELECT @candiscrolallow = [discrolallow] 
            --FROM   [dbo].[trecruittraker] 
            --WHERE  [candidateid] = @candidateid 
            --GROUP  BY [discrolallow], 
            --          [conflictallow], 
            --          [iqallow], 
            --          [eqallow] 

			SELECT @canfiroballow = [firoballow] 
            FROM   [dbo].[trecruitcanbasicdtls]
            WHERE  [candidateid] = @candidateid 
            --GROUP  BY [discrolallow], 
            --          [conflictallow], 
            --          [iqallow], 
            --          [eqallow] 

             
            IF @canfiroballow = 'Completed' 
              BEGIN 
                  UPDATE [dbo].[trecruitcanbasicdtls] 
                  SET    [firoballow] = 'Reschedule' 
                  WHERE  [candidateid] = @candidateid 
              END 
            ELSE 
              BEGIN 
                  SET @message=1 
              END 
        END
end
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: trecruitcanbasicdtls, trecruitcandidatesignup, trecruitconflictexamdtls, trecruitdiscrolexamdtls, trecruitfirobcandidatedtls, trecruitfirobcanlanguagemapping, trecruitfirobexamdtls, trecruitfirobquesdtls, trecruittraker */
/****** Object:  StoredProcedure [dbo].[procfirobmasdtls]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[procfirobmasdtls]
@username varchar(Max),
@action varchar(Max),
@questiondtlsid   INT=NULL,
@number int=null,
@quesserialnonext int=null,
@message VARCHAR(500)=NULL output 
as
declare @candidateid int
declare @maplanid int
declare @countexamques int
declare @attemptno int
declare @quesserialno int
declare @findques int
declare @countexamattm int
declare @countexamattmcan int
declare @countexamattques int
declare @atteptestno int
begin
SELECT @candidateid = candidateid 
      FROM   [dbo].[trecruitcandidatesignup] 
      WHERE  [username] = @username 
SELECT @maplanid = languageid 
            FROM   [dbo].[trecruitfirobcanlanguagemapping] 
            WHERE  candidateid = @candidateid 
SELECT @quesserialno = Min(questionserialno) 
      FROM   [dbo].[trecruitfirobquesdtls] 
      WHERE  languageid = @maplanid 
             AND deleteflag = 'No' 
SELECT @findques = Count(questionserialno) 
      FROM   [dbo].[trecruitfirobcandidatedtls] 
      WHERE  candidateid = @candidateid 
             AND questionserialno = @questiondtlsid 
             AND [quesfinalsubmit] IS NULL 

if(@action ='firobcandidatelanguagemap')
begin
 DELETE FROM [dbo].[trecruitfirobcanlanguagemapping] 
            WHERE  [candidateid] = @candidateid 

            INSERT INTO [dbo].[trecruitfirobcanlanguagemapping] 
                        ([candidateid], 
                         [languageid]) 
            VALUES      (@candidateid, 
                         5 ) 
SELECT @maplanid = languageid 
            FROM   [dbo].[trecruitfirobcanlanguagemapping] 
            WHERE  candidateid = @candidateid 
 SELECT @countexamques = Count([questionserialno]) 
            FROM   [dbo].[trecruitfirobquesdtls] 
            WHERE  [languageid] = @maplanid 
SELECT @attemptno = Count([attemexam]) 
            FROM   [dbo].[trecruitfirobexamdtls] 
            WHERE  [finalsubmit] = 'Yes' 
                   AND candidateid = @candidateid 

DELETE FROM [dbo].[trecruitfirobcandidatedtls] 
            WHERE [quesfinalsubmit]  IS NULL 
                   AND candidateid = @candidateid 

DELETE FROM [dbo].[trecruitfirobexamdtls] 
            WHERE  [finalsubmit] = 'No' 
            AND candidateid = @candidateid 
INSERT INTO [dbo].[trecruitfirobexamdtls] 
                        ([candidateid], 
                         [languageid], 
                         [totalques], 
                         [attemques], 
                         [finalsubmit], 
                         [attemexam]) 
            VALUES      ( @candidateid, 
                          @maplanid, 
                          @countexamques, 
                          NULL, 
                          'No', 
                          @attemptno + 1 )

end
if @action='firobquesansselect'
begin
SELECT previousvalue, 
                   previousvalueques, 
                   questionserialno, 
                   question, 
                   nextvalue, 
                   nextvalueques, 
                   noofques 
            FROM   (SELECT Lag(p.questionserialno) 
                             OVER ( 
                               ORDER BY p.[id]) PreviousValue, 
                           Lag(p.question) 
                             OVER ( 
                               ORDER BY p.[id]) PreviousValueques, 
                           p.questionserialno, 
                           p.question, 
                           Lead(p.questionserialno) 
                             OVER ( 
                               ORDER BY p.[id]) NextValue, 
                           Lead(p.question) 
                             OVER ( 
                               ORDER BY p.[id]) NextValueques, 
                           languageid 
                    FROM   [dbo].[trecruitfirobquesdtls] p 
                    WHERE  languageid = @maplanid 
                           AND deleteflag = 'No')s, 
                   (SELECT languageid, 
                           Count([question])noofques 
                    FROM   [dbo].[trecruitfirobquesdtls] 
                    WHERE  languageid = @maplanid 
                           AND deleteflag = 'No' 
                    GROUP  BY languageid) p 
            WHERE  questionserialno = @quesserialno 
                   AND p.languageid = s.languageid 
end
 IF @action = 'firobquesansselectnext' 
        BEGIN 
		
            SELECT previousvalue, 
                   previousvalueques, 
                   s.questionserialno, 
                   question, 
                   nextvalue, 
                   nextvalueques, 
                   noofques, 
                   CASE 
                     WHEN x.candidateid IS NULL THEN 0 
                     ELSE x.candidateid 
                   END candidateid, 
                   CASE 
                     WHEN x.[answer] IS NULL THEN 0 
                     ELSE x.[answer] 
                   END answer, 
                   CASE 
                     WHEN y.[attemques] BETWEEN 1 AND 100 THEN y.[attemques] 
                     ELSE y.[attemques] 
                   END [attemques] 
            FROM   (SELECT Lag(p.questionserialno) 
                             OVER ( 
                               ORDER BY p.[id]) PreviousValue, 
                           Lag(p.question) 
                             OVER ( 
                               ORDER BY p.[id]) PreviousValueques, 
                           p.questionserialno, 
                           p.question, 
                           Lead(p.questionserialno) 
                             OVER ( 
                               ORDER BY p.[id]) NextValue, 
                           Lead(p.question) 
                             OVER ( 
                               ORDER BY p.[id]) NextValueques, 
                           languageid 
                    FROM   [dbo].[trecruitfirobquesdtls] p 
                    WHERE  languageid = 5 
                           AND deleteflag = 'No')s 
                   LEFT OUTER JOIN 
                   [dbo].[trecruitfirobcandidatedtls] 
                   x 
                                ON s.languageid = x.[languageid] 
                                   AND s.questionserialno = x.[questionserialno] 
                                   AND [quesfinalsubmit]  IS NULL 
                                   AND x.[candidateid] = @candidateid, 
                   (SELECT languageid, 
                           Count([question])noofques 
                    FROM   [dbo].[trecruitfirobquesdtls] 
                    WHERE  languageid = @maplanid 
                           AND deleteflag = 'No' 
                    GROUP  BY languageid) p, 
                   [dbo].[trecruitfirobexamdtls] y 
            WHERE  s.questionserialno= @quesserialnonext 
                   AND p.languageid = s.languageid 
                   AND s.languageid = y.[languageid] 
                   AND y.[candidateid] = @candidateid 
                   AND [finalsubmit] <> 'Yes' 
        END 

IF @action = 'firobcandtlsinsert' 
         AND @findques = 0 
        BEGIN 
            SELECT @countexamattm = [attemexam] 
            FROM   [dbo].[trecruitfirobexamdtls] 
            WHERE  [candidateid] = @candidateid 
                   AND finalsubmit <> 'Yes' 

            SELECT @countexamattmcan = Count([candidateid]) 
            FROM   [dbo].[trecruitfirobexamdtls] 
            WHERE  [candidateid] = @candidateid 

            BEGIN 
                INSERT INTO [dbo].[trecruitfirobcandidatedtls] 
                            ([candidateid], 
                             [languageid], 
                             [questionserialno], 
                             [answer], 
                             candidateattemexam, 
                             [createdon], 
                             [updatedon]) 
                VALUES      ( @candidateid, 
                              @maplanid, 
                              @questiondtlsid, 
                              @number, 
                              @countexamattm, 
                              Getdate(), 
                              Getdate() ) 

                SET @message='Answer Details Successfully Inserted' 
            END 

            SELECT @countexamattques = Count([questionserialno]) 
            FROM   [dbo].[trecruitfirobcandidatedtls] 
            WHERE  candidateid = @candidateid 
                   AND answer <> 0 
                   AND quesfinalsubmit IS NULL 

            IF @countexamattm IS NOT NULL 
              BEGIN 
                  UPDATE [dbo].[trecruitfirobexamdtls] 
                  SET    [attemques] = [totalques] - @countexamattques 
                  WHERE  candidateid = @candidateid 
                         AND finalsubmit <> 'Yes' 
              END 
        END 
 IF @action = 'firobcandtlsinsert' 
         AND @findques > 0 
        BEGIN 
            SELECT @countexamattm = [attemexam] 
            FROM   [dbo].[trecruitfirobexamdtls] 
            WHERE  [candidateid] = @candidateid 
                   AND finalsubmit <> 'Yes' 

            UPDATE [dbo].[trecruitfirobcandidatedtls] 
            SET    [answer] = @number, 
                   [updatedon] = Getdate() 
            WHERE  [candidateid] = @candidateid 
                   AND [questionserialno] = @questiondtlsid 
                   AND [quesfinalsubmit] IS NULL 

            SET @message='Answer Details Successfully Updated' 

            SELECT @countexamattques = Count([questionserialno]) 
            FROM   [dbo].[trecruitfirobcandidatedtls] 
            WHERE  candidateid = @candidateid 
                   AND answer <> 0 
                   AND quesfinalsubmit IS NULL 

            IF @countexamattm IS NOT NULL 
              BEGIN 
                  UPDATE [dbo].[trecruitfirobexamdtls] 
                  SET    [attemques] = [totalques] - @countexamattques 
                  WHERE  candidateid = @candidateid 
                         AND finalsubmit <> 'Yes' 
              END 
        END 
 IF @action = 'firobansqnoselect' 
        BEGIN 
            SELECT @atteptestno = [attemexam] 
            FROM   [dbo].[trecruitfirobexamdtls] 
            WHERE  [finalsubmit] <> 'Yes' 
                   AND [candidateid] = @candidateid 

            SELECT [questionserialno] 
            FROM   [dbo].[trecruitfirobcandidatedtls] 
            WHERE  [answer] > 0 
                   AND [candidateattemexam] = @atteptestno 
                   AND [candidateid] = @candidateid 
        END 
  IF @action = 'Finalsubmit' 
        BEGIN 
            UPDATE [dbo].[trecruitfirobexamdtls] 
            SET    [finalsubmit] = 'Yes' 
            WHERE  candidateid = @candidateid 

            --UPDATE [dbo].[trecruittraker] 
            --SET    [conflictallow] = 'Completed' 
            --WHERE  candidateid = @candidateid 

			---------------------------------------
			UPDATE [dbo].[trecruitcanbasicdtls] 
            SET    [firoballow] = 'Completed' 
            WHERE  candidateid = @candidateid 
			-------------------------------------------

            UPDATE [dbo].[trecruitfirobcandidatedtls] 
            SET    [quesfinalsubmit] = 'F' 
            WHERE  candidateid = @candidateid 

		

	--		select @discrolfinalsubmit=[finalsubmit],@discrolattemexam=[attemexam]
	--		 from [dbo].[trecruitdiscrolexamdtls]
	--		where [candidateid]=@candidateid 

	--		select @conflictfinalsubmit=[finalsubmit],@conflictattemexam=[attemexam]
	--		 from [dbo].[trecruitconflictexamdtls]
	--		where [candidateid]=@candidateid 

	--		if @discrolfinalsubmit='Yes' and @conflictfinalsubmit='Yes'
	--		and @discrolattemexam<2 and @conflictattemexam<2
	--		begin


 --  SELECT @MailId=[MailId]      
 -- FROM [dbo].[trecruitcandidatesignup]
 -- where candidateid=@candidateid

	--EXEC msdb.dbo.sp_send_dbmail
 --   @profile_name = 'Mendine2_Email_Profile'
 --  ,@recipients = @MailId
 --  ,@subject = 'Email from SQL Server'
 --  ,@body = 'This is my First Email sent from SQL Server :)'
 --  ,@importance ='HIGH'
	--		end
        END 
end
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: trecruitcanbasicdtls, trecruitfirobcandidatedtls */
/****** Object:  StoredProcedure [dbo].[procfirobresult]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[procfirobresult]
@candidateattemexam INT=NULL,
@registrationnumber VARCHAR(200)=NULL
as
declare @EIScore int
declare @WCScore int
declare @EAScore int
declare @WIScore int
declare @ECScore int
declare @WAScore int
Declare @candidateid int
begin
SELECT @candidateid = candidateid 
      FROM   [dbo].[trecruitcanbasicdtls] 
      WHERE  registrationnumber = @registrationnumber 

------EI Dimension Score Calculation---------------------

Select @EIScore=sum(score) from
(

select questionserialno,answer,
case 
  when questionserialno=1 and (answer =1 or answer=2 or answer=3 ) then 1
  when questionserialno=1 and (answer =4 or answer=5 or answer=6 ) then 0
  when questionserialno=3 and (answer =1 or answer=2 or answer=3 or answer =4 ) then 1
  when questionserialno=3 and ( answer=5 or answer=6 ) then 0
  when questionserialno=5 and (answer =1 or answer=2 or answer=3 or answer =4 ) then 1
  when questionserialno=5 and ( answer=5 or answer=6 ) then 0
  when questionserialno=7 and (answer =1 or answer=2 or answer=3  ) then 1
  when questionserialno=7 and (answer =4 or answer=5 or answer=6 ) then 0
  when questionserialno=9 and (answer =1 or answer=2   ) then 1
  when questionserialno=9 and (answer=3 or answer =4 or answer=5 or answer=6 ) then 0
  when questionserialno=11 and (answer =1 or answer=2   ) then 1
  when questionserialno=11 and (answer=3 or answer =4 or answer=5 or answer=6 ) then 0
  when questionserialno=13 and (answer =1 or answer=2   ) then 1
  when questionserialno=13 and (answer=3 or answer =4 or answer=5 or answer=6 ) then 0
  when questionserialno=15 and (answer =1  ) then 1
  when questionserialno=15 and (answer=2 or answer=3 or answer =4 or answer=5 or answer=6 ) then 0
  when questionserialno=16 and (answer =1  ) then 1
  when questionserialno=16 and (answer=2 or answer=3 or answer =4 or answer=5 or answer=6 ) then 0
  else 10
end score
from trecruitfirobcandidatedtls 
where candidateid=@candidateid 
and candidateattemexam=@candidateattemexam
and questionserialno in(1,3,5,7,9,11,13,15,16))a

------End Of EI Dimension Score Calculation---------------------

------WC Dimension  Score Calculation--------------------------
Select @WCScore=sum(score)from
 (select questionserialno,answer,
 case 
  when questionserialno=2 and (answer =1 or answer=2 or answer=3 or answer =4 ) then 1
  when questionserialno=2 and (answer=5 or answer=6 ) then 0
  when questionserialno=6 and (answer =1 or answer=2 or answer=3 or answer =4 ) then 1
  when questionserialno=6 and (answer=5 or answer=6 ) then 0
  when questionserialno=10 and (answer =1 or answer=2 or answer=3  ) then 1
  when questionserialno=10 and (answer =4 or answer=5 or answer=6 ) then 0
  when questionserialno=14 and (answer =1 or answer=2 or answer=3  ) then 1
  when questionserialno=14 and (answer =4 or answer=5 or answer=6 ) then 0
  when questionserialno=18 and (answer =1 or answer=2 or answer=3 or answer =4   ) then 1
  when questionserialno=18 and (answer=5 or answer=6 ) then 0
  when questionserialno=20 and (answer =1 or answer=2 or answer=3 or answer =4   ) then 1
  when questionserialno=20 and (answer=5 or answer=6 ) then 0
  when questionserialno=22 and (answer =1 or answer=2 or answer=3 or answer =4   ) then 1
  when questionserialno=22 and (answer=5 or answer=6 ) then 0
  when questionserialno=24 and (answer =1 or answer=2 or answer=3    ) then 1
  when questionserialno=24 and (answer =4 or answer=5 or answer=6 ) then 0
  when questionserialno=26 and (answer =1 or answer=2 or answer=3    ) then 1
  when questionserialno=26 and (answer =4 or answer=5 or answer=6 ) then 0


  else 10
end score
from trecruitfirobcandidatedtls 
where candidateid=@candidateid 
and candidateattemexam=@candidateattemexam
and questionserialno in(2,6,10,14,18,20,22,24,26))b


------End of WC Dimension  Score Calculation---------------------

------ EA Dimension  Score Calculation---------------------------
Select @EAScore=sum(score)from
  (select questionserialno,answer,
 case 
  when questionserialno=4 and (answer =1 or answer=2 ) then 1
  when questionserialno=4 and (answer=3 or answer =4 or answer=5 or answer=6 ) then 0
  when questionserialno=8 and (answer =1 or answer=2 ) then 1
  when questionserialno=8 and (answer=3 or answer =4 or answer=5 or answer=6 ) then 0
  when questionserialno=12 and (answer =1  ) then 1
  when questionserialno=12 and ( answer=2 or answer=3 or answer =4 or answer=5 or answer=6 ) then 0
  when questionserialno=17 and (answer =1 or answer=2   ) then 1
  when questionserialno=17 and (  answer=3 or answer =4 or answer=5 or answer=6 ) then 0
  when questionserialno=19 and (answer =4 or answer=5 or answer=6   ) then 1
  when questionserialno=19 and ( answer =1 or answer=2 or answer=3   ) then 0
  when questionserialno=21 and (answer =1 or answer=2   ) then 1
  when questionserialno=21 and (  answer=3 or answer =4 or answer=5 or answer=6 ) then 0
  when questionserialno=23 and (answer =1 or answer=2   ) then 1
  when questionserialno=23 and (  answer=3 or answer =4 or answer=5 or answer=6 ) then 0
  when questionserialno=25 and (answer =4 or answer=5 or answer=6   ) then 1
  when questionserialno=25 and ( answer =1 or answer=2 or answer=3   ) then 0
  when questionserialno=27 and (answer =1 or answer=2   ) then 1
  when questionserialno=27 and (  answer=3 or answer =4 or answer=5 or answer=6 ) then 0
  else 10
end score
from trecruitfirobcandidatedtls 
where candidateid=@candidateid 
and candidateattemexam=@candidateattemexam
and questionserialno in(4,8,12,17,19,21,23,25,27))c
------ End of EA Dimension  Score Calculation---------------------

------ WI  Dimension  Score Calculation---------------------------
Select @WIScore=sum(score)from
  (select questionserialno,answer,
 case 
  when questionserialno=28 and (answer =1 or answer=2 ) then 1
  when questionserialno=28 and (answer=3 or answer =4 or answer=5 or answer=6 ) then 0
  when questionserialno=31 and (answer =1 or answer=2 ) then 1
  when questionserialno=31 and (answer=3 or answer =4 or answer=5 or answer=6 ) then 0
  when questionserialno=34 and (answer =1 or answer=2 ) then 1
  when questionserialno=34 and (answer=3 or answer =4 or answer=5 or answer=6 ) then 0
  when questionserialno=37 and (answer =1 ) then 1
  when questionserialno=37 and (answer=2 or answer=3 or answer =4 or answer=5 or answer=6 ) then 0
  when questionserialno=39 and (answer =4 or answer=5 or answer=6) then 1
  when questionserialno=39 and (answer =1  or answer=2 or answer=3 ) then 0
  when questionserialno=42 and (answer =1 or answer=2 ) then 1
  when questionserialno=42 and (answer=3 or answer =4 or answer=5 or answer=6 ) then 0
  when questionserialno=45 and (answer =1 or answer=2 ) then 1
  when questionserialno=45 and (answer=3 or answer =4 or answer=5 or answer=6 ) then 0
  when questionserialno=48 and (answer =1 or answer=2 ) then 1
  when questionserialno=48 and (answer=3 or answer =4 or answer=5 or answer=6 ) then 0
  when questionserialno=51 and (answer =1 or answer=2 ) then 1
  when questionserialno=51 and (answer=3 or answer =4 or answer=5 or answer=6 ) then 0
  
  else 10
end score
from trecruitfirobcandidatedtls 
where candidateid=@candidateid 
and candidateattemexam=@candidateattemexam
and questionserialno in(28,31,34,37,39,42,45,48,51))d



------ End Of WI  Dimension  Score Calculation---------------------

------ EC  Dimension  Score Calculation---------------------------

Select @ECScore=sum(score) from
  (select questionserialno,answer,
 case 
  when questionserialno=30 and (answer =1 or answer=2 or answer=3  ) then 1
  when questionserialno=30 and ( answer =4 or answer=5 or answer=6 ) then 0
  when questionserialno=33 and (answer =1 or answer=2 or answer=3  ) then 1
  when questionserialno=33 and ( answer =4 or answer=5 or answer=6 ) then 0
  when questionserialno=36 and (answer =1 or answer=2  ) then 1
  when questionserialno=36 and (answer=3 or answer =4 or answer=5 or answer=6 ) then 0
  when questionserialno=41 and (answer =1 or answer=2  or answer=3 or answer =4  ) then 1
  when questionserialno=41 and ( answer=5 or answer=6 ) then 0
  when questionserialno=44 and (answer =1 or answer=2  or answer=3  ) then 1
  when questionserialno=44 and ( answer =4  or answer=5 or answer=6 ) then 0
  when questionserialno=47 and (answer =1 or answer=2  or answer=3  ) then 1
  when questionserialno=47 and ( answer =4  or answer=5 or answer=6 ) then 0
  when questionserialno=50 and (answer =1 or answer=2    ) then 1
  when questionserialno=50 and ( answer=3 or answer =4  or answer=5 or answer=6 ) then 0
  when questionserialno=53 and (answer =1 or answer=2    ) then 1
  when questionserialno=53 and ( answer=3 or answer =4  or answer=5 or answer=6 ) then 0
  when questionserialno=54 and (answer =1 or answer=2    ) then 1
  when questionserialno=54 and ( answer=3 or answer =4  or answer=5 or answer=6 ) then 0
  else 10
end score
from trecruitfirobcandidatedtls 
where candidateid=@candidateid 
and candidateattemexam=@candidateattemexam
and questionserialno in(30,33,36,41,44,47,50,53,54))e



------ End Of EC  Dimension  Score Calculation---------------------

------ WA  Dimension  Score Calculation---------------------------

Select @WAScore=sum(score)from
  (select questionserialno,answer,
 case 
  when questionserialno=29 and (answer =1 or answer=2    ) then 1
  when questionserialno=29 and ( answer=3 or answer =4  or answer=5 or answer=6 ) then 0
  when questionserialno=32 and (answer =1 or answer=2    ) then 1
  when questionserialno=32 and ( answer=3 or answer =4  or answer=5 or answer=6 ) then 0
  when questionserialno=35 and (  answer=5 or answer=6 ) then 1
  when questionserialno=35 and (answer =1 or answer=2  or answer=3 or answer =4    ) then 0
  when questionserialno=38 and (answer =1 or answer=2    ) then 1
  when questionserialno=38 and ( answer=3 or answer =4  or answer=5 or answer=6 ) then 0
  when questionserialno=40 and (  answer=5 or answer=6 ) then 1
  when questionserialno=40 and (answer =1 or answer=2  or answer=3 or answer =4    ) then 0
  when questionserialno=43 and (answer =1     ) then 1
  when questionserialno=43 and ( answer=2 or answer=3 or answer =4  or answer=5 or answer=6 ) then 0
  when questionserialno=46 and (  answer=5 or answer=6 ) then 1
  when questionserialno=46 and (answer =1 or answer=2  or answer=3 or answer =4    ) then 0
  when questionserialno=49 and (answer =1 or answer=2    ) then 1
  when questionserialno=49 and ( answer=3 or answer =4  or answer=5 or answer=6 ) then 0
  when questionserialno=52 and (  answer=5 or answer=6 ) then 1
  when questionserialno=52 and (answer =1 or answer=2  or answer=3 or answer =4    ) then 0
  else 10
end score
from trecruitfirobcandidatedtls 
where candidateid=@candidateid 
and candidateattemexam=@candidateattemexam
and questionserialno in(29,32,35,38,40,43,46,49,52))e



------ End Of EC  Dimension  Score Calculation---------------------
Select 'EI Dimension' dimension,@EIScore score
union
Select 'WC Dimension' dimension,@WCScore score
union
Select 'EA Dimension' dimension,@EAScore score
union
Select 'WI Dimension' dimension,@WIScore score
union
Select 'EC Dimension' dimension,@ECScore score
Union
Select 'WA Dimension',@WAScore

end
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: tempPsychometricTestMapping, trecruitcanbasicdtls, trecruittraker, trecruittrakeruploadfilefinal, trecruittrakeruploadfileone, trecruittrakeruploadfilethree, trecruittrakeruploadfiletwo */
/****** Object:  StoredProcedure [dbo].[prochrselecttrakerform]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[prochrselecttrakerform]         
@department        VARCHAR(100)=null,                           
 @postname              VARCHAR(100)=null,                           
@applicationstatus     VARCHAR(100)=null,                           
@registrationnumber    VARCHAR(100)=null,                          
@status                VARCHAR(100) = NULL output                           
WITH EXEC AS caller                           
AS                           
  BEGIN                         
                         
   DECLARE @CanNotifyStatus nvarchar(max)                         
   SET @CanNotifyStatus=''                      
                      
  if EXISTS( Select * from trecruitcanbasicdtls where  registrationnumber= @registrationnumber)                      
  Begin                      
     Select @CanNotifyStatus=CanNotifyStatus from trecruitcanbasicdtls where  registrationnumber= @registrationnumber                      
  End                      
                      
                      
                      
      IF @department = ''                           
          OR @postname = ''                           
          OR @applicationstatus = ''                           
        BEGIN                           
            SET @status='Please Select Data for search'                           
                          
            RETURN                           
        END                           
      ELSE                           
        BEGIN                           
  --Select @postname=string.replace(@postname,'%20','')                          
                            
                            
                            
            /****** Script for SelectTopNRows command from SSMS  ******/                           
            SELECT                           
          rs.[registrationnumber],                           
                   rs.[aplicationdate],                           
                   rs.[username],                           
                   rs.[candidateid],                           
                   rs.[candidatename],                           
                   rs.[resumefile],                           
                   rs.[applicationstatus],        
       rs.[PersonalDtlsResubmitStatus],    
       rs.[LanguageDtlsResubmitStatus],    
       rs.[EducationDtlsResubmitStatus],    
       rs.[EmploymentHistoryDtlsResubmitStatus],    
       rs.[AllFormOpenResubmitStatus],    
                   rs.[postname],                           
                   rs.[postid],                           
                   rs.[locid],                           
                   rs.[location],                           
                   rs.[deptdivision],                           
                   case when rt.[source] is null then  rs.[referredus]                          
     else rt.[source] end [referredus],                           
                   rt.[trakerid],                           
                   rt.[referenceno],                           
                   rt.[departmentdivision],                           
                   rt.[departmentdivisonname],                           
                   rt.[postid],                           
                   rt.[postname],                           
                   rt.[locid],                           
                   rt.[headq],                           
                   rt.[candidateid],                           
                   rt.[candidatename],                           
                   rt.[source],                           
                   CONVERT(VARCHAR(10), rt.[startdate], 103)         AS                           
              [STARTDATE],                           
                   rt.[cvselected],                           
    ''[manualupdate],                           
                   CONVERT(VARCHAR(10), rt.[roneinterviewdate], 103) AS                           
           [roneinterviewdate],                           
                   rt.[roneinterviewernameone],                           
                   rt.[roneinterviewernametwo],                           
                   rt.[roneselect],                          
     CONVERT(VARCHAR(10), rt.[roneinterviewenddate], 103) AS                           
                   [roneinterviewenddate],                         
                   rt.[rtwointerviewdate],                           
                 rt.[rtwointerviewernameone],                           
                   rt.[rtwointerviewernametwo],                           
       rt.[rtwoselect],                          
     rt.[rtwointerviewenddate],                        
                   rt.[rthreeinterviewdate],                           
rt.[rthreeinterviewernameone],                           
                   rt.[rthreeinterviewernametwo],                           
                   rt.[rthreeselect],                 
      rt.[rthreeinterviewenddate],                        
                   rt.[frinterviewdate],                           
                   rt.[frinterviewernameone],                    
                   rt.[frinterviewernametwo],                           
                   rt.[frselect],                           
       rt.[Frinterviewenddate],                        
                   rt.[doo],                           
                   rt.[doj],                           
     rt.[empcode],                          
       rt.CompletionStatus,                           
       rt.timetaken,                          
                   rt.[remarks],                                          
                   rt.[createdby],                           
                   rt.[createdtime],                           
                   rt.[modifiedby],                           
                   rt.[modifiedtime],                     
       --Saikat Edit                    
                    
       rt.[FinalInterviewStartTime],                    
       rt.[FinalInterviewEndTime],                           
       rt.[FinalInterviewCallDate],                    
       rt.[FinalInterviewVenue],                           
       rt.[FinalInterviewPending],                                  
       rt.[SelectedCandidateConfirmDate],                
    rt.[CandidateAfterNoResponseDate],             
 rt.[UnderInterviewProcessDate],            
    --convert(varchar,A.PurchaseDate,103)                             
       --rt.[discrolallow],                          
       --rt.[conflictallow],                          
       tb.[iqallow],                          
       tb.[eqallow],                          
       tb.[docsubmissionallow],                          
       tb.[bigfiveallow],                          
       tb.[firoballow],                          
       tb.[myersbriggsallow],                          
       tb.[rotterlocusofcontrolallow],                          
       tb.[personalitystyleinventoryallow],    
        
    tb.[applicationstatus],      
 tb.[PersonalDtlsResubmitStatus],    
       tb.[LanguageDtlsResubmitStatus],    
       tb.[EducationDtlsResubmitStatus],    
       tb.[EmploymentHistoryDtlsResubmitStatus],    
       tb.[AllFormOpenResubmitStatus],    
                   ro.[fileid],                           
                   ro.[candidateid],                           
                   ro.[fname],                           
                   ro.[fcontenttype],                           
                   ro.[fresumefile],                           
                   CASE                           
                     WHEN ro.[fresumefile] IS NULL THEN 'False'                           
                     ELSE 'True'                           
               END      ronerone,                           
                   ro.[sname],                           
                   ro.[scontenttype],                           
             ro.[sresumefile],                           
                   CASE                           
                     WHEN ro.[sresumefile] IS NULL THEN 'False'                           
                     ELSE 'True'                           
                   END                                               ronertwo,                           
                   rtw.[fileid],                           
                   rtw.[candidateid],                           
                   rtw.[fname],                           
                   rtw.[fcontenttype],                           
                   rtw.[fresumefile],                           
                   CASE                           
                     WHEN rtw.[fresumefile] IS NULL THEN 'False'                           
                     ELSE 'True'                           
                   END                                               rtworone,                           
                   rtw.[sname],                           
                   rtw.[scontenttype],                           
                   rtw.[sresumefile],                           
                   CASE                           
                     WHEN rtw.[sresumefile] IS NULL THEN 'False'                           
                     ELSE 'True'                           
                   END                                               rtwortwo,                           
                   rth.[fileid],                           
                   rth.[candidateid],                           
                   rth.[fname],                           
                   rth.[fcontenttype],                           
                   rth.[fresumefile],                                    CASE                           
                     WHEN rth.[fresumefile] IS NULL THEN 'False'                           
                     ELSE 'True'                           
                   END                                               rthworone,                           
                   rth.[sname],                           
                   rth.[scontenttype],                           
                   rth.[sresumefile],                           
                   CASE                           
                     WHEN rth.[sresumefile] IS NULL THEN 'False'                           
                     ELSE 'True'                           
                   END rthwortwo,                           
                   rf.[fileid],                           
                   rf.[candidateid],                           
                   rf.[fname],                           
                   rf.[fcontenttype],                           
                   rf.[fresumefile],                           
                   CASE                           
                     WHEN rf.[fresumefile] IS NULL THEN 'False'                           
         ELSE 'True'                           
                   END                                               rfworone,                           
                   rf.[sname],                           
                   rf.[scontenttype],                           
                   rf.[sresumefile],                           
                   CASE                           
                     WHEN rf.[sresumefile] IS NULL THEN 'False'                           
                     ELSE 'True'                           
                   END                                               rfwortwo ,                      
				   @CanNotifyStatus as CanNotifyStatus,
				    CASE                           
                     WHEN mlq.[MlqAllow] IS NULL THEN 'No'                           
                     ELSE mlq.[MlqAllow]                           
                   END As MlqAllow
				  

						FROM  [dbo].[trecruitcanbasicdtls] tb ,                          
					[vw_recruittracker] rs                           
                   LEFT JOIN [dbo].[trecruittraker] rt                           
                          ON rs.[registrationnumber] = rt.referenceno                           
      AND rs.[postname] = rt.[postname]                           
                   LEFT JOIN [dbo].[trecruittrakeruploadfileone] ro                           
   ON rs.[postid] = ro.postid                           
                             AND rs.locid = ro.locid                           
                AND rs.candidateid = ro.candidateid                           
                   LEFT JOIN [dbo].[trecruittrakeruploadfiletwo] rtw                           
                          ON rs.[postid] = rtw.postid                           
                             AND rs.locid = rtw.locid                           
                             AND rs.candidateid = rtw.candidateid                           
                   LEFT JOIN [dbo].[trecruittrakeruploadfilethree] rth                           
                          ON rs.[postid] = rth.postid                           
                             AND rs.locid = rth.locid                           
                             AND rs.candidateid = rth.candidateid                           
                   LEFT JOIN [dbo].[trecruittrakeruploadfilefinal] rf ON rs.[postid] = rf.postid  
                             AND rs.locid = rf.locid                           
                             AND rs.candidateid = rf.candidateid                           
				   LEFT JOIN [dbo].[tempPsychometricTestMapping] mlq ON rs.candidateid=mlq.CandidateID
            WHERE                            
          --rs.[deptname] = @department                           
                   --AND                           
       rs.[postname] = @postname                           
                   --AND rs.[applicationstatus] = @applicationstatus                           
       and rs.[registrationnumber]=@registrationnumber                          
       and tb.registrationnumber=@registrationnumber                          
                          
                             
        END                           
  END    
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: tempPsychometricTestMapping, test, trecruitcanbasicdtls, trecruitcandidatesignup, trecruitdiscrolecanlanguagemap, trecruittraker, trecruittrakeruploadfilefinal, trecruittrakeruploadfileone, trecruittrakeruploadfilethree, trecruittrakeruploadfiletwo */
/****** Object:  StoredProcedure [dbo].[procinserttrakerform]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procinserttrakerform]                                         
                                       
                                       
                                        
           -- @userName      nvarchar(max)=NULL,                                    
                                    
            @candidateno                   VARCHAR(100)=NULL,                                                          
            @Departmentdivision            VARCHAR(100)=NULL,                                         
            @HeadQ                         VARCHAR(500)=NULL,                                         
            @candidatename                 VARCHAR(500)=NULL,                                    
            @postname                      VARCHAR(100)=NULL,                                    
            @source                        VARCHAR(500)=NULL,                                         
            @STARTDATE                     VARCHAR(500)=NULL,                                         
            @CVSelected                    VARCHAR(10)=NULL,                                         
            @roneinterviewdate             VARCHAR(500)=NULL,                                         
            @roneinterviewernameone        VARCHAR(300)=NULL,                                         
            @roneinterviewernametwo        VARCHAR(300)=NULL,                                         
   @roneinterviewenddate          VARCHAR(500)=NULL,                                      
            @frintervieweronerfile         VARBINARY(max)=NULL,                                         
            @frinterviewertworfile         VARBINARY(max)=NULL,                                         
            @frintervieweroneContentType   VARCHAR(50)=NULL,                                         
            @frinterviewertwoContentType   VARCHAR(50)=NULL,                                         
            @frintervieweronefilename      VARCHAR(50)=NULL,                                         
            @frinterviewertwofilename      VARCHAR(50) =NULL,                                        
   @roneselect      VARCHAR(10)=NULL,                                        
            @rtwointerviewdate             VARCHAR(300)=NULL,                                        
            @rtwointerviewernameone        VARCHAR(300)=NULL,                                        
            @rtwointerviewernametwo        VARCHAR(300)=NULL,                                        
   @rtwointerviewenddate             VARCHAR(300)=NULL,                                        
   @srintervieweronerfile         VARBINARY(max)=NULL,                                         
            @srinterviewertworfile         VARBINARY(max)=NULL,                                         
            @srintervieweroneContentType   VARCHAR(50)=NULL,                                         
            @srinterviewertwoContentType   VARCHAR(50)=NULL,                                         
            @srintervieweronefilename      VARCHAR(50)=NULL,                                         
            @srinterviewertwofilename      VARCHAR(50) =NULL,                                          
   @rtwoselect                    VARCHAR(10)=NULL,                                        
            @rthreeinterviewdate           VARCHAR(300)=NULL,                                        
            @rthreeinterviewernameone      VARCHAR(300)=NULL,                                        
            @rthreeinterviewernametwo      VARCHAR(300)=NULL,                                        
   @rthreeinterviewenddate           VARCHAR(300)=NULL,                                        
   @trintervieweronerfile         VARBINARY(max)=NULL,                                         
            @trinterviewertworfile         VARBINARY(max)=NULL,                                         
            @trintervieweroneContentType   VARCHAR(50)=NULL,                        
            @trinterviewertwoContentType   VARCHAR(50)=NULL,                                       
            @trintervieweronefilename      VARCHAR(50)=NULL,                                         
            @trinterviewertwofilename      VARCHAR(50) =NULL,                                          
   @rthreeselect                  VARCHAR(10)=NULL,                                        
            @rfinalinterviewdate           VARCHAR(300)=NULL,                                        
            @rfinalinterviewernameone      VARCHAR(300)=NULL,                                      
            @rfinalinterviewernametwo      VARCHAR(300)=NULL,                            
 --                                
 -- Selected Candidate Confirm Date Final Interview Pending Date                           
                          
 --EXEC dbo.proc_CandidateNotification @CanNotifyStatus,@regno,@sltCandConfirmDate,@finalinterviewdate,@finalinterviewStartTime                            
 --,@finalinterviewEndTime,@rfinalinterviewendVenue,@finalInterviewPandingDate;                             
-- @status nvarchar(max),                                              
--@registrationnumber nvarchar(max),                               
-- @sltCandConfirmDate varchar(300)=NULL,                                    
-- @finalinterviewdate varchar(300)=NULL,                              
-- @finalinterviewStartTime   VARCHAR(400)=NULL,                                
-- @finalinterviewEndTime   VARCHAR(400)=NULL,                              
--@rfinalinterviewendVenue     VARCHAR(MAX)=NULL,                              
--@finalInterviewPandingDate varchar(400)=NULL                              
                            
  @CanNotifyStatus      nvarchar(max)=NULL,                             
  @regno    nvarchar(max)=NULL,                            
  @sltCandConfirmDate varchar(300)=NULL,                            
  @finalinterviewdate varchar(300)=NULL,                            
  @finalinterviewStartTime   VARCHAR(400)=NULL,                            
  @finalinterviewEndTime   VARCHAR(400)=NULL,                            
  @finalinterviewendVenue     VARCHAR(MAX)=NULL,                            
  @finalInterviewPandingDate varchar(300)=NULL,                          
  @candidateAfterNoResponseDate nvarchar(max)=null,                     
  @candUndrInterviewProcessDate nvarchar(max)=null,                  
                             
 @rfinalinterviewenddate           VARCHAR(300)=NULL,                                            
   @firintervieweronerfile        VARBINARY(max)=NULL,                                         
            @firinterviewertworfile        VARBINARY(max)=NULL,                                         
            @firintervieweroneContentType  VARCHAR(50)=NULL,                                         
          @firinterviewertwoContentType  VARCHAR(50)=NULL,                                         
            @firintervieweronefilename     VARCHAR(50)=NULL,                                         
            @firinterviewertwofilename     VARCHAR(50) =NULL,                                        
   @firselect                     VARCHAR(10)=NULL,                                        
   @DOO                           VARCHAR(300)=NULL,                                        
   @DOJ                           VARCHAR(300)=NULL,                                        
   @EmployeeCode                  VARCHAR(300)=NULL,                                        
   @Remarks                       VARCHAR(300)=NULL,                                        
   @CompletionStatus             VARCHAR(300)=NULL,                                        
   @timetaken                     VARCHAR(300)=NULL,                                        
   @discrollallow                 VARCHAR(50)=NULL,                                         
   @conflictallow                 VARCHAR(50)=NULL,     
   @iqallow                       VARCHAR(50)=NULL,                                         
   @eqallow                       VARCHAR(50)=NULL ,       
   @docuploadallow                VARCHAR(50)=NULL ,                                        
   @bigfiveallow                  VARCHAR(50)=NULL,                                        
   @firoballow                    VARCHAR(50)=NULL,                                        
   @myersbriggsallow               VARCHAR(50)=NULL,                                        
   @rotterlocusofcontrolallow      VARCHAR(50)=NULL,                                        
   @personalitystyleinventoryallow VARCHAR(50)=NULL,         
           
   @PersonalDtlsResubmitStatus varchar(50)=Null,        
   @FamilyLanguageDtlsResubmitStatus varchar(50)=Null,        
   @EducationDtlsResubmitStatus varchar(50)=Null,        
   @EmploymentHistoryDtlsResubmitStatus varchar(50)=Null,        
   @AllFormOpenResubmitStatus varchar(50)=Null,    
   @MlqAllow VARCHAR(50)=NULL,    
   @MlqAllowExamUrl nvarchar(MAX)=NULL    
        
  -- @resubmitStatus varchar(50)=NULL          
AS                                         
  BEGIN                                    
      DECLARE @postid INT                                         
      DECLARE @locid INT                                         
      DECLARE @candidateid INT             
   declare @cancount int                                        
   declare @empcount int           
   DECLARE @resubmittedStatus varchar(50)        
           
  if(@PersonalDtlsResubmitStatus IS NOT NULL        
   OR @FamilyLanguageDtlsResubmitStatus IS NOT NULL        
    OR @EducationDtlsResubmitStatus IS NOT NULL        
    OR @EmploymentHistoryDtlsResubmitStatus IS NOT NULL        
    OR @AllFormOpenResubmitStatus IS NOT NULL)                               
   Begin        
    SET @resubmittedStatus='RESUBMIT'        
   End        
     ELSE        
     BEGIN        
     SET @resubmittedStatus='NEW'        
     END        
 select                                           
   @postid = [postid],                                         
      @locid = [locid]                  
   from [dbo].[vw_recruittracker]                                         
   where  [postname] = @postname                                        
                                        
   SELECT @cancount=count([referenceno])                                                         FROM   [dbo].[trecruittraker]                                         
      WHERE  [referenceno] = @candidateno                                          
                         
     select @candidateid=[candidateid] FROM [dbo].[trecruitcanbasicdtls]                                        
     where registrationnumber=@candidateno                                        
                                       
  select @empcount=count([candidateid]) from [dbo].[trecruitdiscrolecanlanguagemap]                                   
  where candidateid=@candidateid                                         
                                        
 --Notify to the email                                     
if(@CanNotifyStatus <>'')                                    
Begin                                  
 --If not((select CanNotifyStatus from [trecruitcanbasicdtls]                     
 --   where registrationnumber=@regno)=@CanNotifyStatus               
 --   and(select CanNotifyStatus from [trecruitcanbasicdtls]                     
 --   where registrationnumber=@regno)=NULL)                    
 -- Begin                    
 --  EXEC dbo.proc_CandidateNotification @CanNotifyStatus,@regno,@sltCandConfirmDate,@finalinterviewdate,@finalinterviewStartTime,@finalinterviewEndTime,@finalinterviewendVenue,@finalInterviewPandingDate,@candidateAfterNoResponseDate,@candUndrInterviewProcessDate;                    
 -- end                              
  IF (   (SELECT CanNotifyStatus     FROM [trecruitcanbasicdtls]           WHERE registrationnumber = @regno) IS NULL   OR    NOT   (SELECT CanNotifyStatus     FROM [trecruitcanbasicdtls]           WHERE registrationnumber = @regno) = @CanNotifyStatus)   
  
    
      
  BEGIN               
 EXEC dbo.proc_CandidateNotification @CanNotifyStatus,@regno,@sltCandConfirmDate,@finalinterviewdate,@finalinterviewStartTime,@finalinterviewEndTime,@finalinterviewendVenue,@finalInterviewPandingDate,@candidateAfterNoResponseDate,@candUndrInterviewProcessDate;     END            
  End                                                             
      IF NOT EXISTS(SELECT [referenceno],                                         
                           postname                                         
             FROM   [dbo].[trecruittraker]                                         
                    WHERE  [referenceno] = @candidateno                                         
                           AND postname = @postname)                                         
        BEGIN                                               INSERT INTO [trecruittraker]                                         
                        (referenceno,                                         
                         departmentdivision,                                        postid,                                         
                         postname,                                         
                         locid,                                         
                         headq,                                         
                         candidateid,                                         
                         candidatename,                                         
                         source,                                         
                         startdate,                                         
                         cvselected,                                         
                         roneinterviewdate,                                       
                         roneinterviewernameone,                                         
                         roneinterviewernametwo,                                         
      [roneselect],                                      
       [roneinterviewenddate],                                      
                         [rtwointerviewdate],                                         
                         [rtwointerviewernameone],                                         
                         [rtwointerviewernametwo],                                      
                         [rtwoselect],                                      
                      [rtwointerviewenddate],                                      
                         [rthreeinterviewdate],                                        
                         [rthreeinterviewernameone],                                        
                         [rthreeinterviewernametwo],                                        
                         [rthreeselect],                                        
       [rthreeinterviewenddate],                                      
      [Frinterviewdate],                                        
                         [Frinterviewernameone],                                        
                         [Frinterviewernametwo],                                        
  [frselect],                                        
       [Frinterviewenddate],                                      
       [DOO]                                        
       ,[DOJ]                                        
      ,[Empcode]                                        
      ,CompletionStatus                                        
      ,timetaken                                        
      ,[Remarks]                                        
      ,[discrolallow]                                        
         ,[conflictallow]                                        
      --,[iqallow]                                        
     --,[eqallow]                                        
       )                                         
            VALUES      ( @candidateno,                                         
                          @Departmentdivision,                                         
                          @postid,                                         
                  @postname,                               
                          @locid,                                         
                          @HeadQ,                                         
                          @candidateid,                                         
                          @candidatename,                                         
             @source,                                                                  
                          CONVERT(VARCHAR, @STARTDATE, 103),                        
                          @CVSelected,                                                                   
      CONVERT(VARCHAR, @roneinterviewdate, 103),                                         
                     @roneinterviewernameone,                                         
                          @roneinterviewernametwo,                                         
                          @roneselect,                                   
        CONVERT(VARCHAR, @roneinterviewenddate, 103),                                        
                          CONVERT(VARCHAR, @rtwointerviewdate, 103),                                         
                          @rtwointerviewernameone,                                         
                          @rtwointerviewernametwo,                                        
        @rtwoselect,                                      
   CONVERT(VARCHAR, @rtwointerviewenddate, 103),                                         
        CONVERT(VARCHAR, @rthreeinterviewdate, 103),                                        
                          @rthreeinterviewernameone,                                        
                          @rthreeinterviewernametwo,                                        
        @rthreeselect,                                        
  CONVERT(VARCHAR, @rthreeinterviewenddate, 103),                       
                          @rfinalinterviewdate,                                        
                          @rfinalinterviewernameone,                                        
                         @rfinalinterviewernametwo,                                        
        @firselect,                                                
  @rfinalinterviewenddate,                                      
        CONVERT(VARCHAR, @DOO, 103),                                                         
        CONVERT(VARCHAR, @DOJ, 103),                                        
                 @EmployeeCode,                                        
        @CompletionStatus,                                        
        @timetaken,                                        
                 @Remarks,                                        
        @discrollallow,                                         
        @conflictallow                                         
       -- @iqallow,                                         
       -- @eqallow                                         
                                                
        )                                         
     --            if @cancount=2                                        
     --begin                                        
     --update [trecruittraker]                                         
     --set    [discrolallow]=@discrollallow,                                         
     -- conflictallow=@conflictallow,                                         
     -- iqallow=@iqallow,                                    
     -- eqallow= @eqallow                                         
     -- WHERE  [referenceno] = @candidateno                  
     --            end                                        
  --------ADD BY SOUMENDU------------------------                                        
  UPDATE [dbo].[trecruitcanbasicdtls]                                        
  SET  [eqallow]=@eqallow                                         
 WHERE [registrationnumber]=@candidateno                                        
 and ([eqallow] is null or [eqallow]='No')                                        
                            
 UPDATE [dbo].[trecruitcanbasicdtls]                                        
  SET [iqallow]=@iqallow                                           
 WHERE [registrationnumber]=@candidateno                                        
 and ([iqallow] is null or [iqallow]='No')                                        
                                   
 UPDATE [dbo].[trecruitcanbasicdtls]                                        
  SET [bigfiveallow]=@bigfiveallow                                          
 WHERE [registrationnumber]=@candidateno                                        
 and ([bigfiveallow] is null or [bigfiveallow]='No')                                  
                                         
 UPDATE [dbo].[trecruitcanbasicdtls]                                        
  SET [firoballow]=@firoballow                                          
 WHERE [registrationnumber]=@candidateno                                        
 and ([firoballow] is null or [firoballow]='No')                                        
                                        
 UPDATE [dbo].[trecruitcanbasicdtls]                                        
 SET [myersbriggsallow]=@myersbriggsallow                                          
 WHERE [registrationnumber]=@candidateno                                        
 and ([myersbriggsallow] is null or [myersbriggsallow]='No')                                        
                                       
 UPDATE [dbo].[trecruitcanbasicdtls]                                        
 SET [rotterlocusofcontrolallow]=@rotterlocusofcontrolallow                                          
 WHERE [registrationnumber]=@candidateno                                        
 and ([rotterlocusofcontrolallow] is null or [rotterlocusofcontrolallow]='No')                                        
                                        
 UPDATE [dbo].[trecruitcanbasicdtls]                                        
 SET [personalitystyleinventoryallow]=@personalitystyleinventoryallow                                          
 WHERE [registrationnumber]=@candidateno                           
 and ([personalitystyleinventoryallow] is null or [personalitystyleinventoryallow]='No')                                        
                                     
 UPDATE [dbo].[trecruitcanbasicdtls]                                        
  SET [docsubmissionallow]=@docuploadallow                                          
 WHERE [registrationnumber]=@candidateno                                        
                                         
----------------Saikat Start Put Resubmit Status----------------          
 UPDATE [dbo].[trecruitcanbasicdtls]                                        
  SET [applicationstatus]=@resubmittedStatus,        
  PersonalDtlsResubmitStatus=@PersonalDtlsResubmitStatus,        
  LanguageDtlsResubmitStatus=@FamilyLanguageDtlsResubmitStatus,        
  EducationDtlsResubmitStatus=@EducationDtlsResubmitStatus,        
  EmploymentHistoryDtlsResubmitStatus=@EmploymentHistoryDtlsResubmitStatus,        
  AllFormOpenResubmitStatus=@AllFormOpenResubmitStatus        
 WHERE [registrationnumber]=@candidateno                                        
----------------Saikat Start Put Resubmit Status----------------          
          
          
 -----------END----------------------------------                                        
        END                                         
      ELSE                                         
        BEGIN                     
            UPDATE [trecruittraker]                                         
SET    headq = @HeadQ,                                         
                   startdate = CONVERT(CHAR(10), @STARTDATE, 126),                                         
                   cvselected = @CVSelected,                                         
       source=@source,                                        
                   roneinterviewdate = CONVERT(CHAR(10), @roneinterviewdate, 126),                                         
                   roneinterviewernameone = @roneinterviewernameone,                                         
                   roneinterviewernametwo = @roneinterviewernametwo,                                         
                   [roneselect] = @roneselect,                                         
       [roneinterviewenddate]=CONVERT(CHAR(10), @roneinterviewenddate, 126),                                      
                   [rtwointerviewdate] = CONVERT(CHAR(10), @rtwointerviewdate,126),                                         
                   [rtwointerviewernameone] = @rtwointerviewernameone,                                         
                   [rtwointerviewernametwo] = @rtwointerviewernametwo ,                                       
                  [rtwoselect]=@rtwoselect,                                        
                [rtwointerviewenddate]= CONVERT(CHAR(10), @rtwointerviewenddate,126),                                      
                   [rthreeinterviewdate] = CONVERT(VARCHAR, @rthreeinterviewdate, 103),                                        
                   [rthreeinterviewernameone]=@rthreeinterviewernameone,                                        
    [rthreeinterviewernametwo]=@rthreeinterviewernametwo,                                        
                   [rthreeselect]= @rthreeselect,                                        
       [rthreeinterviewenddate] = CONVERT(VARCHAR, @rthreeinterviewenddate, 103),                 
                   [Frinterviewdate]=@rfinalinterviewdate,                                        
                   [Frinterviewernameone]=@rfinalinterviewernameone,                                        
                   [Frinterviewernametwo]=@rfinalinterviewernametwo,                                        
                   [frselect]= @firselect,                                      
       [Frinterviewenddate] = @rfinalinterviewenddate,                                      
       [DOO]=CONVERT(VARCHAR, @DOO, 103),                                        
                   [DOJ]=CONVERT(VARCHAR, @DOJ, 103),                                        
       [Empcode]=@EmployeeCode,                         
       timetaken=@timetaken,                                        
       [Remarks]=@Remarks,                                               
       CompletionStatus=@CompletionStatus,                                        
       [discrolallow]=@discrollallow,                                        
       [conflictallow]=@conflictallow                                        
      -- [iqallow]=@iqallow,                                        
      -- [eqallow]=@eqallow                                        
            WHERE  referenceno = @candidateno                                         
                   AND postname = @postname                                         
                                     
     --   if @empcount=0                                        
     --begin                                            
     --update [trecruittraker]                        
     --set    [discrolallow]=@discrollallow,                                         
     -- conflictallow=@conflictallow,                                         
     -- iqallow=@iqallow,                                         
     -- eqallow= @eqallow                                         
     -- WHERE  [referenceno] = @candidateno                 
     --            end                                        
  --------ADD BY SOUMENDU------------------------                                        
  UPDATE [dbo].[trecruitcanbasicdtls]                                        
  SET  [eqallow]=@eqallow                                         
 WHERE [registrationnumber]=@candidateno                                        
 and ([eqallow] is null or [eqallow]='No')                                        
                                        
 UPDATE [dbo].[trecruitcanbasicdtls]                  
  SET [iqallow]=@iqallow                                            
 WHERE [registrationnumber]=@candidateno                              
 and ([iqallow] is null or [iqallow]='No')                                        
                                        
 UPDATE [dbo].[trecruitcanbasicdtls]                                        
  SET [bigfiveallow]=@bigfiveallow                                          
 WHERE [registrationnumber]=@candidateno                                        
 and ([bigfiveallow] is null or [bigfiveallow]='No')                                        
 UPDATE [dbo].[trecruitcanbasicdtls]                                        
  SET [firoballow]=@firoballow                                          
 WHERE [registrationnumber]=@candidateno                                        
 and ([firoballow] is null or [firoballow]='No')                                        
                                        
 UPDATE [dbo].[trecruitcanbasicdtls]                                        
 SET [myersbriggsallow]=@myersbriggsallow                                          
 WHERE [registrationnumber]=@candidateno                                        
 and ([myersbriggsallow] is null or [myersbriggsallow]='No')                                        
                                        
 UPDATE [dbo].[trecruitcanbasicdtls]                     
 SET [rotterlocusofcontrolallow]=@rotterlocusofcontrolallow                                          
 WHERE [registrationnumber]=@candidateno                                        
 and ([rotterlocusofcontrolallow] is null or [rotterlocusofcontrolallow]='No')                                        
                                        
 UPDATE [dbo].[trecruitcanbasicdtls]                                        
 SET [personalitystyleinventoryallow]=@personalitystyleinventoryallow                                          
 WHERE [registrationnumber]=@candidateno                                        
 and ([personalitystyleinventoryallow] is null or [personalitystyleinventoryallow]='No')                                        
                                        
 UPDATE [dbo].[trecruitcanbasicdtls]                                        
  SET [docsubmissionallow]=@docuploadallow                           
 WHERE [registrationnumber]=@candidateno             
           
       
 ----------------------MLQ TEST ASSING START-----------------------------------      
 IF NOT EXISTS(SELECT * FROM [tempPsychometricTestMapping] WHERE CandidateID=@candidateid)    
 BEGIN    
  --SELECT * FROM [tempPsychometricTestMapping]    
    
  IF @MlqAllow IS NOT NULL    
  BEGIN    
      Declare @MailId varchar(max)                                   
   Declare @tableHTML nvarchar(max)                                  
   Declare @mailSubject nvarchar(max)       
   Declare @CandidaFullName nvarchar(max)      
   --Declare @PostName nvarchar(max)      
   Declare @CandidateMail nvarchar(max)      
       
       
    
   SELECT @CandidateMail=MailId FROM trecruitcandidatesignup WHERE CandidateID=@candidateid    
    
    
   INSERT [tempPsychometricTestMapping]    
    (CandidateID, MlqAllow, lastMlqStatusChange)    
   VALUES(@candidateid, 'Yes', GETDATE());    
    
       
       
    
   SET @mailSubject = 'Invitation to Complete the Multifactor Leadership Questionnaire (MLQ)';    
    
       
  -- HTML Body    
   SET @tableHTML =     
   '<table style="font-size:16px; font-family:Tahoma; line-height:22px; width:650px;">    
      <tr>    
     <td>Dear ' + @CandidateName + ',</td>    
      </tr>    
    
      <tr><td style="height:15px;"></td></tr>    
    
      <tr>    
     <td>    
       As part of our commitment to understanding and developing strong leadership,     
       we would like to invite you to complete the <b>Multifactor Leadership Questionnaire (MLQ)</b>.     
       This psychometric assessment will provide valuable insights into your leadership style </b>.    
     </td>    
      </tr>    
    
      <tr><td style="height:20px;"></td></tr>    
    
          
      <tr><td style="height:20px;"></td></tr>    
    
      <tr>    
     <td>    
       <b>How to Start:</b><br/>    
       To begin the assessment, please click on the link below:<br/><br/>    
       <a href="' + @MlqAllowExamUrl + '"     
       style="background-color:#0E7777; color:#ffffff; padding:10px 18px;     
        text-decoration:none; border-radius:6px; font-weight:bold;">    
      Start the MLQ Test    
       </a>    
     </td>    
      </tr>    
    
      <tr><td style="height:20px;"></td></tr>    
    
      <tr>    
     <td>    
       We recommend taking the test in a quiet, distraction-free environment to ensure you can focus.    
     </td>    
      </tr>    
    
      <tr><td style="height:20px;"></td></tr>    
    
      <tr>    
     <td>    
       The results of this assessment will be used to help you, your manager, and our leadership team     
       understand your unique strengths and how you can be most effective in your role.    
     </td>    
      </tr>    
    
      <tr><td style="height:20px;"></td></tr>    
    
      <tr>    
     <td>    
       If you have any questions or experience any technical issues,     
       please contact concerned HR, or <a href="mailto:bipro.das@mendine.com">bipro.das@mendine.com</a>.    
     </td>    
      </tr>    
    
      <tr><td style="height:30px;"></td></tr>    
    
      <tr>    
     <td>    
       Thank you for your cooperation. We look forward to seeing your results.    
     </td>    
      </tr>    
    
      <tr><td style="height:30px;"></td></tr>    
    
      <tr>    
     <td>    
       Thanks & Regards,<br/><i>Mendine HR Team</i>     
     </td>    
          </tr>    
    </table>';    
    
        
                   EXEC msdb.dbo.sp_send_dbmail        
                    @profile_name = 'Mendine_Recruitment_Profile'        
                    , @recipients = @CandidateMail        
                    , @subject = @mailSubject        
                    , @body = @tableHTML        
                    , @importance = 'HIGH'        
                   , @body_format = 'HTML'       
    
  END    
 END     
 ----------------------MLQ TEST ASSING END-----------------------------------      
           
----------------Saikat Start Put Resubmit Status----------------          
 UPDATE [dbo].[trecruitcanbasicdtls]                                        
  SET [applicationstatus]=@resubmittedStatus,          
  PersonalDtlsResubmitStatus=@PersonalDtlsResubmitStatus,        
  LanguageDtlsResubmitStatus=@FamilyLanguageDtlsResubmitStatus,        
  EducationDtlsResubmitStatus=@EducationDtlsResubmitStatus,        
  EmploymentHistoryDtlsResubmitStatus=@EmploymentHistoryDtlsResubmitStatus,        
  AllFormOpenResubmitStatus=@AllFormOpenResubmitStatus        
        
 WHERE [registrationnumber]=@candidateno                                        
----------------Saikat Start Put Resubmit Status----------------          
 -----------END----------------------------------                                        
                                        
                                        
        END                                         
                                        
      IF NOT EXISTS (SELECT [candidateid],                                         
                            postid,                                         
                            locid                                         
                     FROM   [trecruittrakeruploadfileone]                                         
                     WHERE  [candidateid] = @candidateid                                         
             AND postid = @postid                                         
                            AND locid = @locid)                                         
        BEGIN                                         
            INSERT INTO [trecruittrakeruploadfileone]                                         
                        ([candidateid],                                         
                         postid,                                         
                         locid,                                         
                         [fname],                                         
                         [fcontenttype],                                         
                         [fresumefile],                  
                         [sname],                                         
                         [scontenttype],                                         
                         [sresumefile])                                         
            VALUES      ( @candidateid,                                         
                          @postid,                                         
       @locid,                                         
                          @frintervieweronefilename,                                         
                          @frintervieweroneContentType,             
                          @frintervieweronerfile,                                         
 @frinterviewertwofilename,                                         
                          @frinterviewertwoContentType,                                         
                          @frinterviewertworfile )                                         
        END                                         
      ELSE IF @frintervieweroneContentType IS NOT NULL                                         
          AND @frinterviewertwoContentType IS NOT NULL                                         
        BEGIN                                         
            UPDATE [trecruittrakeruploadfileone]                                         
            SET    [fname] = @frintervieweronefilename,                                         
                   [fcontenttype] = @frintervieweroneContentType,                          
                   [fresumefile] = @frintervieweronerfile,                                         
                   [sname] = @frinterviewertwofilename,                                         
                   [scontenttype] = @frinterviewertwoContentType,                                         
                   [sresumefile] = @frinterviewertworfile                                         
            WHERE  candidateid = @candidateid                                         
                   AND [postid] = @postid                                         
                   AND [locid] = @locid                     
        END                                         
      ELSE IF @frintervieweroneContentType IS NOT NULL                                         
        BEGIN                                         
            UPDATE [trecruittrakeruploadfileone]                                         
            SET    [fname] = @frintervieweronefilename,                                         
                   [fcontenttype] = @frintervieweroneContentType,                                         
                   [fresumefile] = @frintervieweronerfile                                         
            WHERE  candidateid = @candidateid                                         
                   AND [postid] = @postid                                         
                   AND [locid] = @locid                                         
        END                                         
      ELSE IF @frinterviewertwoContentType IS NOT NULL                                     
        BEGIN                                         
UPDATE [trecruittrakeruploadfileone]                                         
            SET    [sname] = @frinterviewertwofilename,                                         
                   [scontenttype] = @frinterviewertwoContentType,                                         
                   [sresumefile] = @frinterviewertworfile                                         
       WHERE  candidateid = @candidateid                                         
                   AND [postid] = @postid                                         
 AND [locid] = @locid                                         
        END                                         
  END                                         
                                        
IF NOT EXISTS (SELECT [candidateid],                                         
                      postid,                                         
           locid                                         
               FROM   [trecruittrakeruploadfiletwo]                                         
             WHERE  [candidateid] = @candidateid                                         
                    AND postid = @postid                                         
                      AND locid = @locid)                                         
  BEGIN                                         
      INSERT INTO [trecruittrakeruploadfiletwo]                                         
                  ([candidateid],                                         
                   postid,                                         
                   locid,                          
                   [fname],                                         
                   [fcontenttype],                                         
                   [fresumefile],                                         
                   [sname],                                         
                   [scontenttype],                                         
                   [sresumefile])                    
      VALUES      ( @candidateid,                                         
                    @postid,                                         
                    @locid,                                         
                    @srintervieweronefilename,                                         
                    @srintervieweroneContentType,                                         
                    @srintervieweronerfile,                                         
                    @srinterviewertwofilename,                                         
                    @srinterviewertwoContentType,                                         
                    @srinterviewertworfile )                                         
  END                                         
ELSE IF @srintervieweroneContentType IS NOT NULL                                         
    AND @srinterviewertwoContentType IS NOT NULL                                         
  BEGIN                                         
      UPDATE [trecruittrakeruploadfiletwo]                                         
      SET    [fname] = @srintervieweronefilename,                                         
             [fcontenttype] = @srintervieweroneContentType,                                         
             [fresumefile] = @srintervieweronerfile,                                         
       [sname] = @srinterviewertwofilename,                                         
             [scontenttype] = @srinterviewertwoContentType,                                         
             [sresumefile] = @srinterviewertworfile                                         
      WHERE  candidateid = @candidateid                                         
             AND [postid] = @postid                                         
             AND [locid] = @locid                                         
  END                                         
ELSE IF @srintervieweroneContentType IS NOT NULL                                      
  BEGIN                                         
      UPDATE [trecruittrakeruploadfiletwo]                                         
      SET    [fname] = @srintervieweronefilename,                                         
             [fcontenttype] = @srintervieweroneContentType,                                         
             [fresumefile] = @srintervieweronerfile                                         
      WHERE  candidateid = @candidateid                                         
             AND [postid] = @postid                                         
             AND [locid] = @locid                                         
  END                                         
ELSE IF @srinterviewertwoContentType IS NOT NULL                                         
  BEGIN                                    
      UPDATE [trecruittrakeruploadfiletwo]                                         
      SET    [sname] = @srinterviewertwofilename,                                         
             [scontenttype] = @srinterviewertwoContentType,                                         
             [sresumefile] = @srinterviewertworfile                                         
      WHERE  candidateid = @candidateid                                         
             AND [postid] = @postid                                         
             AND [locid] = @locid                                         
                                        
END                                         
IF NOT EXISTS (SELECT [candidateid],                                         
                      postid,                                         
                   locid                                         
               FROM   [trecruittrakeruploadfilethree]                                   
               WHERE  [candidateid] = @candidateid                                         
   AND postid = @postid                                         
                      AND locid = @locid)                                         
  BEGIN                                         
      INSERT INTO [trecruittrakeruploadfilethree]                                         
                  ([candidateid],                                         
            postid,                                         
                   locid,                                         
                   [fname],                                         
                   [fcontenttype],                                         
                   [fresumefile],                            
                   [sname],                                         
                   [scontenttype],                                         
                   [sresumefile])                                         
      VALUES      ( @candidateid,                                         
                    @postid,                        
                    @locid,                                         
                    @trintervieweronefilename,                                         
                    @trintervieweroneContentType,                                         
                    @trintervieweronerfile,                                         
                    @trinterviewertwofilename,                                         
               @trinterviewertwoContentType,                                         
                    @trinterviewertworfile )                                         
  END                                         
ELSE IF @trintervieweroneContentType IS NOT NULL                                         
   AND @trinterviewertwoContentType IS NOT NULL                                    
  BEGIN                                         
      UPDATE [trecruittrakeruploadfilethree]                                         
      SET  [fname] = @trintervieweronefilename,                                         
             [fcontenttype] = @trintervieweroneContentType,                                         
             [fresumefile] = @trintervieweronerfile,                                         
             [sname] = @trinterviewertwofilename,                                         
             [scontenttype] = @trinterviewertwoContentType,                                         
             [sresumefile] = @trinterviewertworfile                                         
      WHERE  candidateid = @candidateid                                         
             AND [postid] = @postid                                         
             AND [locid] = @locid                                         
  END                                         
ELSE IF @trintervieweroneContentType IS NOT NULL                                         
  BEGIN                                         
      UPDATE [trecruittrakeruploadfilethree]                                         
      SET    [fname] = @trintervieweronefilename,                                         
             [fcontenttype] = @trintervieweroneContentType,                                         
             [fresumefile] = @trintervieweronerfile                                         
      WHERE  candidateid = @candidateid                                         
             AND [postid] = @postid                                         
             AND [locid] = @locid                                         
  END                                         
ELSE IF @trinterviewertwoContentType IS NOT NULL                                         
  BEGIN                                         
      UPDATE [trecruittrakeruploadfilethree]                                         
      SET    [sname] = @trinterviewertwofilename,                                         
             [scontenttype] = @trinterviewertwoContentType,                                         
             [sresumefile] = @trinterviewertworfile                                         
    WHERE  candidateid = @candidateid                                         
             AND [postid] = @postid                                         
             AND [locid] = @locid                              
                                        
END                                         
IF NOT EXISTS (SELECT [candidateid],                                         
                      postid,                                         
                      locid                                         
               FROM   [trecruittrakeruploadfilefinal]                                         
               WHERE  [candidateid] = @candidateid                                         
                      AND postid = @postid                                         
                      AND locid = @locid)                                         
  BEGIN                                         
      INSERT INTO [trecruittrakeruploadfilefinal]                                         
                  ([candidateid],                                         
                   postid,                                         
               locid,                                         
                   [fname],                           
                   [fcontenttype],                                         
                   [fresumefile],                                         
                   [sname],                                         
                   [scontenttype],                                         
                   [sresumefile])                                         
      VALUES      ( @candidateid,                                         
                    @postid,                                         
                    @locid,                                         
                    @firintervieweronefilename,                                        
                    @firintervieweroneContentType,                                         
              @firintervieweronerfile,                                         
                    @firinterviewertwofilename,                                         
                    @firinterviewertwoContentType,                                         
                    @firinterviewertworfile )                                         
  END                                   
ELSE IF @firintervieweroneContentType IS NOT NULL                                         
   AND @firinterviewertwoContentType IS NOT NULL                                         
  BEGIN                                         
      UPDATE [trecruittrakeruploadfilefinal]                                         
      SET    [fname] = @firintervieweronefilename,                                         
             [fcontenttype] = @firintervieweroneContentType,                                         
             [fresumefile] = @firintervieweronerfile,                                         
             [sname] = @firinterviewertwofilename,                                         
             [scontenttype] = @firinterviewertwoContentType,        
             [sresumefile] = @firinterviewertworfile                                         
      WHERE  candidateid = @candidateid                                         
             AND [postid] = @postid                                         
             AND [locid] = @locid                                         
  END                                         
ELSE IF @firintervieweroneContentType IS NOT NULL                                         
  BEGIN                                       UPDATE [trecruittrakeruploadfilefinal]                                         
      SET    [fname] = @firintervieweronefilename,                                         
             [fcontenttype] = @firintervieweroneContentType,                                         
             [fresumefile] = @firintervieweronerfile                                         
      WHERE  candidateid = @candidateid                                         
             AND [postid] = @postid                                         
             AND [locid] = @locid                                         
  END                                         
ELSE IF @firinterviewertwoContentType IS NOT NULL                                         
  BEGIN                                         
      UPDATE [trecruittrakeruploadfilefinal]                                         
    SET    [sname] = @firinterviewertwofilename,                                         
             [scontenttype] = @firinterviewertwoContentType,                                         
             [sresumefile] = @firinterviewertworfile                                         
      WHERE  candidateid = @candidateid                                         
             AND [postid] = @postid                                         
             AND [locid] = @locid                                         
                                    
--proc_CandidateNotification 'Under interview process','DUMMY USER TEST','Candidate006135'                                    
                                    
                                  
   --   select @CanNotifyStatus                                  
END 
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: trecruitcanbasicdtls, trecruitiqansmarks, trecruitiqcandidatedtls, trecruitiqexamdtls, trecruittraker */
/****** Object:  StoredProcedure [dbo].[prociqhrdtls]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Script for SelectTopNRows command from SSMS  ******/      
      
CREATE procedure [dbo].[prociqhrdtls]       
@action             VARCHAR(100)=NULL,       
@candidateattemexam INT=NULL,      
@registrationnumber VARCHAR(200)=NULL,      
@Message            VARCHAR(200)=NULL       
as      
DECLARE @candidateid INT       
DECLARE @iqallow     VARCHAR(200)      
begin      
      
SELECT @candidateid = candidateid       
      FROM   [dbo].[trecruitcanbasicdtls]       
      WHERE  registrationnumber = @registrationnumber       
      
IF @action = 'SELECTEXAMNO'       
        BEGIN       
            SELECT [attemexam],       
                   CASE       
                     WHEN [attemexam] = 1 THEN Cast('1st Exam' AS VARCHAR)       
                     WHEN [attemexam] = 2 THEN Cast('2nd Exam'AS VARCHAR)       
                     WHEN [attemexam] = 3 THEN Cast('3rd Exam'AS VARCHAR)       
                     ELSE Cast([attemexam]AS VARCHAR) + '' + 'th Exam'       
                   END [attemexamtext]       
            FROM   [dbo].[trecruitiqexamdtls]       
            WHERE  candidateid = @candidateid       
                   AND finalsubmit = 'Yes'       
            ORDER  BY [attemexam]       
        END       
      
IF @action = 'IQResult'       
begin      
      
select  b.[firstname]+' '+b.[middlename]+' '+b.[lastname] Empname,      
p.[position],a.Scoresbetween,a.Rating,Comment      
      
 from      
(SELECT  a.candidateid, (SELECT Comment from trecruitiqexamdtls where candidateid=@candidateid and attemexam=@candidateattemexam)Comment,      
    count(a.[Serialno])Scoresbetween,      
     case when count(a.[Serialno]) between 27 and 30 then 'Very highly exceptional'      
  when count(a.[Serialno]) between 24 and 26 then 'High expert'      
  when count(a.[Serialno]) between 21 and 23 then 'Expert'      
  when count(a.[Serialno]) between 19 and 20 then 'Very high average'      
  when count(a.[Serialno]) between 17 and 18 then 'High average'      
  when count(a.[Serialno]) between 13 and 16 then 'Middle average'      
  when count(a.[Serialno]) between 10 and 12 then 'Low average'      
  when count(a.[Serialno]) between 6 and 9 then 'Borderline low'      
  when count(a.[Serialno]) between 3 and 5 then 'Low'      
  when count(a.[Serialno]) between 0 and 2 then 'very low'      
      end Rating      
  FROM [dbo].[trecruitiqcandidatedtls] a,      
  [dbo].[trecruitiqansmarks] b      
  where a.candidateid=@candidateid      
  and a.[questionid]=b.[questionno]      
  and a.[answer]=b.[answerno]      
  and b.[marks]=1      
  and a.[candidateattemexam]=@candidateattemexam      
  group by a.candidateid) a,[vw_canapppost] p,[trecruitcanbasicdtls] b      
  where a.candidateid=p.candidateid      
  and a.candidateid=b.candidateid      
       
  end      
      
   IF @action = 'Activeinactiveresbutton'       
        BEGIN       
            SELECT       
                   a.[iqallow]       
            FROM   [dbo].[trecruitcanbasicdtls] a                       
            WHERE   a.candidateid = @candidateid       
        END       
      
  IF @action = 'Reschedule'       
        BEGIN       
            --SELECT @candiscrolallow = [discrolallow]       
            --FROM   [dbo].[trecruittraker]       
            --WHERE  [candidateid] = @candidateid       
            --GROUP  BY [discrolallow],       
            --          [conflictallow],       
            --          [iqallow],       
            --          [eqallow]       
      
   SELECT @iqallow = [iqallow]       
            FROM   [dbo].[trecruitcanbasicdtls]      
            WHERE  [candidateid] = @candidateid       
            GROUP  BY [discrolallow],       
                      [conflictallow],       
                      [iqallow],       
                      [eqallow]       
      
                   
            IF @iqallow = 'Completed'       
              BEGIN       
                  UPDATE [dbo].[trecruitcanbasicdtls]       
                  SET    [iqallow] = 'Reschedule'       
        WHERE  [candidateid] = @candidateid       
              END       
            ELSE       
              BEGIN       
                  SET @message=1       
              END       
        END       
      
  end
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: Languages, tempPsychometricTestMapping, trecruitcanbasicdtls, trecruitcandidatesignup, trecruitdiscrolcandidatedtls, trecruitdiscrolqusdtls, trecruitiqansmarks, trecruitiqcandidatedtls, trecruitiqcanlanguagemap, trecruitiqexamdtls, trecruitiqquesdtls, trecruitiqrandomques, trecruittraker */
/****** Object:  StoredProcedure [dbo].[prociqmasdtls]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*  
Declare @message Varchar(500)=''  
exec prociqmasdtls @action='IQquesansselect',@username='IQtest', @message=output  
Select @message  
  
  
*/  
CREATE PROC [dbo].[prociqmasdtls]      @action           NVARCHAR(100)=NULL,   
                                      @disquestype      NVARCHAR(100)=NULL,   
                                      @username         NVARCHAR(100)=NULL,   
                                      @activeflag       NVARCHAR(10)=NULL,   
                                      @disquestypeid    INT=NULL,   
                                      @languageid       INT=NULL,   
                                      @question         NVARCHAR(max)=NULL,   
                                      @questiondtlsid   INT=NULL,   
                                      @answer           NVARCHAR(max)=NULL,   
                                      @number           INT=NULL,   
                                      @answerdtlsid     INT=NULL,   
                                      @quesserialnonext INT=NULL,   
                                      @ollanguageid     INT=NULL,   
                                      @olquesserialno   INT=NULL,   
                                      @message          VARCHAR(500)=NULL output   
AS   
    DECLARE @empcode VARCHAR(100)   
    DECLARE @candidateid INT   
    DECLARE @anslanguageid INT   
    DECLARE @queslanguageid INT   
    DECLARE @countexamques INT   
    DECLARE @countexamattm INT   
    DECLARE @countexamattques INT   
    DECLARE @quesserialno INT   
    DECLARE @maplanid INT   
    DECLARE @countexamattmcan INT   
    DECLARE @findques INT   
    DECLARE @idd INT   
    DECLARE @attemptno INT   
    DECLARE @cattemptno INT   
    DECLARE @atteptestno INT   
    DECLARE @quesset INT   
    DECLARE @aquesset INT   
    DECLARE @createdtime DATETIME   
    DECLARE @cancreatedtime DATETIME   
    DECLARE @orquesserialno INT   
    DECLARE @canquesset INT   
 DECLARE @sRanquesserialno int  
 declare @empno int         ---ishita  
  
  BEGIN   
  
  Begin Tran
  
    set @languageid=5  
 set @maplanid=5  
      SELECT @empcode = empcode   
      FROM   essp.dbo.emp   
      WHERE  empemail = @username   
  
   SELECT @empno = empno   
      FROM   [essp].[dbo].[Empbasic]   ------ishita  
      WHERE  [empemail] = @username   
   and empstatus='ACTIVE'  
  
  
      SELECT @candidateid = candidateid   
      FROM   [Recruitment].[dbo].[trecruitcandidatesignup]   
      WHERE  [username] = @username   
  
      --SELECT @maplanid = languageid   
      --FROM   [Recruitment].[dbo].[trecruitiqcanlanguagemap] p   
      --WHERE  candidateid = @candidateid   
  
      --SELECT @createdtime = Max([createddate])   
      --FROM   [Recruitment].[dbo].[trecruitiqrandomques] p   
      --WHERE  languageid = @maplanid   
  
      SELECT @cancreatedtime = Max([createddate])   
      FROM   [Recruitment].[dbo].[trecruitiqrandomques] p   
  
  
      --WHERE  languageid = @maplanid   
             --AND candidateid = @candidateid   
  
      --SELECT @quesset = quesset   
      --FROM   [Recruitment].[dbo].[trecruitiqrandomques] p   
      --WHERE   createddate = @createdtime   
  
      SELECT @canquesset = quesset   
      FROM   [Recruitment].[dbo].[trecruitiqrandomques] p   
      WHERE   createddate = @cancreatedtime   
            -- AND candidateid = @candidateid   
  
       IF @canquesset = 1   
        BEGIN   
            SET @aquesset=@canquesset + 1   
        END   
      ELSE IF @canquesset = 2   
       BEGIN   
            SET @aquesset=@canquesset + 1   
      END   
      ELSE IF @canquesset = 3   
       BEGIN   
           SET @aquesset=@canquesset-2   
       END   
  
   
  
      SELECT @countexamques = Count([quesserialno])   
      FROM   [Recruitment].[dbo].[trecruitiqquesdtls]   
      WHERE   [queslanset] = @canquesset   
  
      SELECT @quesserialno = Min([ranquesserialno])   
      FROM   [Recruitment].[dbo].[trecruitiqquesdtls] p   
      WHERE  languageid = 5               
      AND  [queslanset] = @canquesset   
  
      SELECT @countexamattm = [attemexam]   
   FROM  [Recruitment].[dbo].[trecruitiqexamdtls]   
            WHERE  [candidateid] = @candidateid   
                   AND finalsubmit <> 'Yes'   
  
      SELECT @orquesserialno = [quesserialno]   
      FROM   [Recruitment].[dbo].[trecruitiqquesdtls] ans   
      WHERE  [queslanset] = @canquesset   
             AND [ranquesserialno] = @questiondtlsid   
  
      SELECT @findques = Count(questionid)   
      FROM   [Recruitment].[dbo].[trecruitiqcandidatedtls]   
      WHERE  candidateid = @candidateid   
             AND questionid = @orquesserialno   
             AND [quesfinalsubmitques] IS NULL   
   
 IF @action = 'iqcandidatelanguagemap'   
        BEGIN   
            DELETE FROM [dbo].[trecruitiqcanlanguagemap]   
            WHERE  [candidateid] = @candidateid   
  
            INSERT INTO [dbo].[trecruitiqcanlanguagemap]   
                        ([candidateid],   
                         [languageid])   
            VALUES      (@candidateid,   
                         @languageid )   
  
            INSERT INTO [dbo].[trecruitiqrandomques]   
                        ([languageid],   
                         [quesset],   
                         [createddate],   
                         candidateid)   
            VALUES      (@languageid,   
                         @aquesset,   
                         Getdate(),   
                         @candidateid )   
  
            SELECT @maplanid = languageid   
            FROM   [Recruitment].[dbo].[trecruitiqcanlanguagemap] p   
            WHERE  candidateid = @candidateid   
  
            SELECT @countexamques = Count([quesserialno])   
            FROM   [Recruitment].[dbo].[trecruitiqquesdtls]   
            WHERE  [languageid] = @maplanid   
                   AND [queslanset] = @canquesset   
  
            SELECT @attemptno = Count([attemexam])   
            FROM   [Recruitment].[dbo].[trecruitiqexamdtls]   
            WHERE  [finalsubmit] = 'Yes'   
                   AND candidateid = @candidateid   
  
            DELETE FROM [Recruitment].[dbo].[trecruitiqcandidatedtls]   
            WHERE  [quesfinalsubmitques] IS NULL   
                   AND candidateid = @candidateid   
  
            DELETE FROM [Recruitment].[dbo].[trecruitiqexamdtls]   
            WHERE  [finalsubmit] = 'No'   
                   AND candidateid = @candidateid   
  
            INSERT INTO [Recruitment].[dbo].[trecruitiqexamdtls]   
                        ([candidateid],   
                         [languageid],   
                         [totalques],   
                         [attemques],   
                         [finalsubmit],   
                         [attemexam])   
            VALUES      ( @candidateid,   
                          @languageid,   
                          @countexamques,   
                          NULL,   
                          'No',   
                          @attemptno + 1 )   
        END   
  
      IF @action = 'IQquesansselect'   
        BEGIN   
  
   SELECT @orquesserialno=[quesserialno]        
  FROM [Recruitment].[dbo].[trecruitiqquesdtls]  
  where [Queslanset]=@canquesset and [Ranquesserialno]=@quesserialno  
  
           SELECT previousvalue,                     
                   ranquesserialno quesserialno,   
                   question,   
                   nextvalue,                      
                   noofques ,  
       quescount noofoption  
            FROM   (SELECT Lag(p.ranquesserialno)   
                             OVER (   
                               ORDER BY p.[ranquesserialno]) PreviousValue,   
                           Lag(p.question)   
                             OVER (   
                               ORDER BY p.[ranquesserialno]) PreviousValueques,   
                           p.ranquesserialno,   
                           p.question,   
         p.[quesserialno],  
                           Lead(p.ranquesserialno)   
                             OVER (   
                               ORDER BY p.[ranquesserialno]) NextValue,   
                           Lead(p.question)   
                             OVER (   
                               ORDER BY p.[ranquesserialno]) NextValueques,   
                           languageid   
                    FROM   [Recruitment].[dbo].[trecruitiqquesdtls] p   
                    WHERE  languageid = 5                            
                     AND [queslanset] = @canquesset)s,   
                   (SELECT languageid,   
                           Count([quesserialno])noofques   
                    FROM   [Recruitment].[dbo].[trecruitiqquesdtls]   
                    WHERE  languageid = 5                              
                           AND [queslanset] = @canquesset  
                    GROUP  BY languageid) p ,(SELECT questionno,count([answerno])quescount  
        
                 FROM [Recruitment].[dbo].[trecruitiqansmarks]  
                             where questionno=@orquesserialno   
                              group by questionno)w  
            WHERE  ranquesserialno = @quesserialno   
                   AND p.languageid = s.languageid   
         
        END   
  
      IF @action = 'IQquesansselectnext'   
  
   SELECT @orquesserialno=[quesserialno]  
        
  FROM [Recruitment].[dbo].[trecruitiqquesdtls]  
  where [Queslanset]=@canquesset and [Ranquesserialno]=@quesserialnonext  
  
        BEGIN   
            SELECT previousvalue,   
                      
                   ranquesserialno quesserialno,   
                   question,   
                   nextvalue,   
                     
                   noofques,   
       quescount noofoption,  
                   CASE   
                     WHEN x.candidateid IS NULL THEN 0   
                     ELSE x.candidateid   
                   END             candidateid,   
                   CASE   
                     WHEN x.[answer] IS NULL THEN 0   
                     ELSE x.[answer]   
                   END             answer,   
                   CASE   
                     WHEN y.[attemques] BETWEEN 1 AND 100 THEN y.[attemques]   
                     ELSE y.[attemques]   
                   END             [attemques]   
            FROM   (SELECT Lag(p.ranquesserialno)   
                             OVER (   
                               ORDER BY p.[ranquesserialno]) PreviousValue,   
                           Lag(p.question)   
                             OVER (   
                               ORDER BY p.[ranquesserialno]) PreviousValueques,   
                           p.ranquesserialno,   
                           p.quesserialno,   
                           p.question,   
                           Lead(p.ranquesserialno)   
                             OVER (   
                               ORDER BY p.[ranquesserialno]) NextValue,   
                           Lead(p.question)   
                             OVER (   
                               ORDER BY p.[ranquesserialno]) NextValueques,   
                           languageid   
                    FROM   [Recruitment].[dbo].[trecruitiqquesdtls] p   
                    WHERE  languageid = 5   
                             
                           AND [queslanset] = @canquesset)s   
                   LEFT OUTER JOIN   
                   [Recruitment].[dbo].[trecruitiqcandidatedtls]   
                   x   
                                ON s.languageid = x.[languageid]   
                                   AND s.quesserialno = x.[questionid]   
                                   AND [quesfinalsubmitques] IS NULL   
                                   AND x.[candidateid] = @candidateid,   
                   (SELECT languageid,   
                           count([quesserialno])noofques   
                    FROM   [Recruitment].[dbo].[trecruitiqquesdtls]   
                    WHERE  languageid = 5   
                             
                           AND [queslanset] = @canquesset   
                    GROUP  BY languageid) p, (SELECT questionno,count([answerno])quescount  
        
                 FROM [Recruitment].[dbo].[trecruitiqansmarks]  
                             where questionno=@orquesserialno  
                              group by questionno)w,  
                   [Recruitment].[dbo].[trecruitiqexamdtls] y   
            WHERE  ranquesserialno = @quesserialnonext   
                   AND p.languageid = s.languageid   
                   AND s.languageid = y.[languageid]   
                   AND y.[candidateid] = @candidateid   
                   AND [finalsubmit] = 'No'   
        
        END   
  
      IF @action = 'IQansselect'   
        BEGIN   
  SELECT @orquesserialno = [quesserialno]   
            FROM   [Recruitment].[dbo].[trecruitiqquesdtls] ans   
            WHERE  [queslanset] = @canquesset   
                   AND [ranquesserialno] = @questiondtlsid   
  
            SELECT [answerno],   
                   [answer],   
                   language   
            FROM   [Recruitment].[dbo].[trecruitiqansmarks] ans,   
                   [Recruitment].[dbo].[languages] lan ,[Recruitment].[dbo].[trecruitiqquesdtls] qus   
            WHERE  ans.[languageid] = lan.[id]   
                   AND lan.[id] = 5  
       and ans.[questionno]=qus.[quesserialno]  
       and qus.[quesserialno]=@orquesserialno  
        END   
  
      IF @action = 'IQolquesansselect'   
        BEGIN   
      SELECT @orquesserialno = [quesserialno]   
            FROM   [Recruitment].[dbo].[trecruitiqquesdtls] ans   
            WHERE  [queslanset] = @canquesset   
                   AND [ranquesserialno] = @questiondtlsid   
  
            SELECT [question]   
            FROM   [Recruitment].[dbo].[trecruitiqquesdtls]   
            WHERE  languageid = 5  
                   AND ranquesserialno = @olquesserialno   
                   AND [queslanset] = @canquesset   
  
            SELECT [answerno],   
                   [answer],   
                   language   
            FROM   [Recruitment].[dbo].[trecruitiqansmarks] ans,   
                   [Recruitment].[dbo].[languages] lan ,[Recruitment].[dbo].[trecruitiqquesdtls] qus   
            WHERE  ans.[languageid] = lan.[id]   
                   AND lan.[id] = 5  
       and ans.[questionno]=qus.[quesserialno]  
       and qus.[quesserialno]=@orquesserialno  
        END   
        
      IF @action = 'IQcandtlsinsert'   
         AND @findques = 0   
        BEGIN   
            SELECT @countexamattm = [attemexam]   
            FROM   [Recruitment].[dbo].[trecruitiqexamdtls]   
            WHERE  [candidateid] = @candidateid   
                   AND finalsubmit <> 'Yes'   
  
            SELECT @countexamattmcan = Count([candidateid])   
            FROM   [Recruitment].[dbo].[trecruitiqexamdtls]   
            WHERE  [candidateid] = @candidateid   
  
            SELECT @orquesserialno = [quesserialno]   
            FROM   [Recruitment].[dbo].[trecruitiqquesdtls] ans   
            WHERE  [queslanset] = @canquesset   
                   AND [ranquesserialno] = @questiondtlsid   
  
            BEGIN   
                INSERT INTO [Recruitment].[dbo].[trecruitiqcandidatedtls]   
                            ([candidateid],   
                             exquesset,   
        [Serialno],  
                             [languageid],   
                             [questionid],   
                             [answer],   
                             candidateattemexam,   
                             [createdon],   
                             [updatedon])   
                VALUES      ( @candidateid,   
                              @canquesset,   
         @questiondtlsid,  
                              @maplanid,   
                              @orquesserialno,   
                              @number,   
                              @countexamattm,   
                              Getdate(),   
                              Getdate() )   
  
                SET @message='Answer Details Successfully Inserted'   
            END   
  
            SELECT @countexamattques = Count([questionid])   
            FROM   [Recruitment].[dbo].[trecruitiqcandidatedtls]   
      WHERE  candidateid = @candidateid   
                   AND answer <> 0   
                   AND quesfinalsubmitques IS NULL   
  
            IF @countexamattm IS NOT NULL   
              BEGIN   
                  UPDATE [Recruitment].[dbo].[trecruitiqexamdtls]   
                  SET    [attemques] = [totalques] - @countexamattques   
                  WHERE  candidateid = @candidateid   
                         AND finalsubmit = 'No'   
              END   
        END   
  
      IF @action = 'IQcandtlsinsert'   
         AND @findques > 0   
        BEGIN   
            SELECT @countexamattm = [attemexam]   
            FROM   [Recruitment].[dbo].[trecruitiqexamdtls]   
            WHERE  [candidateid] = @candidateid   
                   AND finalsubmit = 'No'   
  
            SELECT @orquesserialno = [quesserialno]   
            FROM   [Recruitment].[dbo].[trecruitiqquesdtls] ans   
            WHERE  [queslanset] = @canquesset   
                   AND [ranquesserialno] = @questiondtlsid   
  
            UPDATE [Recruitment].[dbo].[trecruitiqcandidatedtls]   
            SET    [answer] = @number,   
                   [updatedon] = Getdate()   
            WHERE  [candidateid] = @candidateid   
                   AND [questionid] = @orquesserialno   
                   AND [quesfinalsubmitques] IS NULL   
  
            SET @message='Answer Details Successfully Updated'   
  
            SELECT @countexamattques = Count([questionid])   
            FROM   [Recruitment].[dbo].[trecruitiqcandidatedtls]   
            WHERE  candidateid = @candidateid   
                   AND answer <> 0   
                   AND quesfinalsubmitques IS NULL   
  
            IF @countexamattm IS NOT NULL   
              BEGIN   
                  UPDATE [Recruitment].[dbo].[trecruitiqexamdtls]   
                  SET    [attemques] = [totalques] - @countexamattques   
                  WHERE  candidateid = @candidateid   
                         AND finalsubmit = 'No'   
              END   
        END   
  
      IF @action = 'Finalsubmit'   
        BEGIN   
  
  INSERT INTO [Recruitment].[dbo].[trecruitiqcandidatedtls]   
                            ( candidateid,  
                             exquesset,   
        [Serialno],  
                             [languageid],   
                             [questionid],   
                             [answer],  
        createdon,                               
                             [updatedon],  
        [candidateattemexam])   
  
        select @candidateid,  
        [Queslanset],  
        [Ranquesserialno],  
        5,  
        [quesserialno],  
        0,  
        getdate(),  
        getdate(),  
        @countexamattm  
         from [Recruitment].[dbo].[trecruitiqquesdtls]  
        where [Queslanset]=1  
        and [Ranquesserialno] not in (SELECT [Serialno]        
                             FROM [Recruitment].[dbo].[trecruitiqcandidatedtls]  
                            where candidateid=@candidateid)  
        order by [Ranquesserialno]  
  
            UPDATE [Recruitment].[dbo].[trecruitiqexamdtls]   
            SET    [finalsubmit] = 'Yes'   
            WHERE  candidateid = @candidateid   
  
            --UPDATE [Recruitment].[dbo].[trecruittraker]     
            --SET    [discrolallow] = 'Completed'     
            --WHERE  candidateid = @candidateid     
            -----------------------------------------    
            UPDATE [Recruitment].[dbo].[trecruitcanbasicdtls]   ----- ishita change  
            SET    [iqallow] = 'Completed'   
            WHERE  candidateid = @candidateid   
  
   UPDATE [essp].[dbo].[temppsychometrictestmapping]   
            SET    [IQTest] = 'Completed'         ------ishita  
            WHERE  empno = @empno  
  
            -------------------------------------------    
            UPDATE [dbo].[trecruitiqcandidatedtls]   
            SET    [quesfinalsubmitques] = 'F'   
            WHERE  candidateid = @candidateid   
        END   
  
      IF @action = 'IQcandtlsselect'   
BEGIN   
   SELECT disc.[id],   
                   disc.[candidateid],   
                   disc.[languageid],   
                   disc.[questionid],   
                   ques.[question],   
                   disc.[answer]   
            FROM   [Recruitment].[dbo].[trecruitiqcandidatedtls] disc,   
                   [dbo].[trecruitiqquesdtls] ques   
            WHERE  [candidateid] = @candidateid   
                   AND [questionid] = @questiondtlsid   
                   AND disc.[questionid] = ques.id   
        END   
  
      IF @action = 'IQcandtlsselect'   
        BEGIN   
            IF NOT EXISTS (SELECT candidateid   
                           FROM   
                   [Recruitment].[dbo].[trecruitiqcandidatedtls]   
                           WHERE  candidateid = @candidateid)   
              BEGIN   
                  SELECT @sRanquesserialno=Min([Ranquesserialno])  
                  FROM   [Recruitment].[dbo].[trecruitiqquesdtls]   
                  WHERE  [languageid] = 5                            
                  and [Queslanset]=@canquesset  
       
  
                  SELECT [number],   
                         [answer]   
                  FROM   [Recruitment].[dbo].[trecruitiqansdtls]   
                  WHERE  [languageid] = @languageid   
                         AND activeflag = 'Yes'   
              END   
        --SELECT disc.[id],                      
        --       disc.[candidateid],                      
        --       disc.[languageid],                      
        --       disc.[questionid],                      
        --       ques.[question],                      
        --       disc.[answer]                      
        --FROM   [Recruitment].[dbo].[trecruitdiscrolcandidatedtls] disc,                      
        --       [dbo].[trecruitdiscrolqusdtls] ques                      
        --WHERE  [candidateid] = @candidateid                      
        --       AND [questionid] = @questiondtlsid                      
        --       AND disc.[questionid] = ques.id                      
        END   
  
      IF @action = 'IQansqnoselect'   
        BEGIN   
            SELECT @atteptestno = [attemexam]   
            FROM   [Recruitment].[dbo].[trecruitiqexamdtls]   
            WHERE  [finalsubmit] = 'No'   
                   AND [candidateid] = @candidateid   
  
            SELECT [Serialno] questionid   
            FROM   [Recruitment].[dbo].[trecruitiqcandidatedtls]   
            WHERE  [answer] > 0   
                   AND [candidateattemexam] = @atteptestno   
                   AND [candidateid] = @candidateid   
        END   
		Commit Tran
  END   
  
  
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: trecruitcanbasicdtls, trecruitmyersbiggsexamdtls, trecruittraker */
/****** Object:  StoredProcedure [dbo].[procmyersbriggshrdtls]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[procmyersbriggshrdtls]
@candidateattemexam INT=NULL, 
@registrationnumber VARCHAR(200)=NULL,
@action varchar(200),
@Message            VARCHAR(200)=NULL 
as
declare @candidateid int
declare @canmyerabriggsallow varchar(100)

begin
SELECT @candidateid = candidateid 
      FROM   [dbo].[trecruitcanbasicdtls] 
      WHERE  registrationnumber = @registrationnumber 
IF @action = 'SELECTEXAMNO' 
        BEGIN 
            SELECT [attemexam], 
                   CASE 
                     WHEN [attemexam] = 1 THEN Cast('1st Exam' AS VARCHAR) 
                     WHEN [attemexam] = 2 THEN Cast('2nd Exam'AS VARCHAR) 
                     WHEN [attemexam] = 3 THEN Cast('3rd Exam'AS VARCHAR) 
                     ELSE Cast([attemexam]AS VARCHAR) + '' + 'th Exam' 
                   END [attemexamtext] 
            FROM   [dbo].trecruitmyersbiggsexamdtls
            WHERE  candidateid = @candidateid 
                   AND finalsubmit = 'Yes' 
            ORDER  BY [attemexam] 
        END 
IF @action = 'Activeinactiveresbutton' 
        BEGIN 
            SELECT 
                   a.[myersbriggsallow] 
            FROM   [dbo].[trecruitcanbasicdtls] a                
            WHERE a.candidateid = @candidateid 
        END 
  IF @action = 'Reschedule' 
        BEGIN 
            --SELECT @candiscrolallow = [discrolallow] 
            --FROM   [dbo].[trecruittraker] 
            --WHERE  [candidateid] = @candidateid 
            --GROUP  BY [discrolallow], 
            --          [conflictallow], 
            --          [iqallow], 
            --          [eqallow] 

			SELECT @canmyerabriggsallow = [myersbriggsallow] 
            FROM   [dbo].[trecruitcanbasicdtls]
            WHERE  [candidateid] = @candidateid 
            --GROUP  BY [discrolallow], 
            --          [conflictallow], 
            --          [iqallow], 
            --          [eqallow] 

             
            IF @canmyerabriggsallow = 'Completed' 
              BEGIN 
                  UPDATE [dbo].[trecruitcanbasicdtls] 
                  SET    [myersbriggsallow] = 'Reschedule' 
                  WHERE  [candidateid] = @candidateid 
              END 
            ELSE 
              BEGIN 
                  SET @message=1 
              END 
        END
end
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: trecruitcanbasicdtls, trecruitcandidatesignup, trecruitconflictexamdtls, trecruitdiscrolexamdtls, trecruitmyersbiggsexamdtls, trecruitmyersbriggsanswer, trecruitmyersbriggscandidatedtls, trecruitmyersbriggscanlanguagemapping, trecruitmyersbriggsquesdtls, trecruittraker */
/****** Object:  StoredProcedure [dbo].[procmyersbriggsmasdtls]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[procmyersbriggsmasdtls]
@username varchar(Max),
@action varchar(Max),
@questiondtlsid   INT=NULL,
@number varchar(20)=null,
@quesserialnonext int=null,
@message VARCHAR(500)=NULL output 
as
declare @candidateid int
declare @maplanid int
declare @countexamques int
declare @attemptno int
declare @quesserialno int
declare @findques int
declare @countexamattm int
declare @countexamattmcan int
declare @countexamattques int
declare @atteptestno int
begin
SELECT @candidateid = candidateid 
      FROM   [dbo].[trecruitcandidatesignup] 
      WHERE  [username] = @username 
SELECT @maplanid = languageid 
            FROM   [dbo].[trecruitmyersbriggscanlanguagemapping] 
            WHERE  candidateid = @candidateid 
SELECT @quesserialno = Min(questionserialno) 
      FROM   [dbo].[trecruitmyersbriggsquesdtls] 
      WHERE  languageid = @maplanid 
             AND deleteflag = 'No' 
SELECT @findques = Count(questionserialno) 
      FROM   [dbo].[trecruitmyersbriggscandidatedtls] 
      WHERE  candidateid = @candidateid 
             AND questionserialno = @questiondtlsid 
             AND [quesfinalsubmit] IS NULL 

if(@action ='myersbriggscandidatelanguagemap')
begin
 DELETE FROM [dbo].[trecruitmyersbriggscanlanguagemapping] 
            WHERE  [candidateid] = @candidateid 

            INSERT INTO [dbo].[trecruitmyersbriggscanlanguagemapping] 
                        ([candidateid], 
                         [languageid]) 
            VALUES      (@candidateid, 
                         5 ) 
SELECT @maplanid = languageid 
            FROM   [dbo].[trecruitmyersbriggscanlanguagemapping] 
            WHERE  candidateid = @candidateid 
 SELECT @countexamques = Count([questionserialno]) 
            FROM   [dbo].[trecruitmyersbriggsquesdtls] 
            WHERE  [languageid] = @maplanid 
SELECT @attemptno = Count([attemexam]) 
            FROM   [dbo].[trecruitmyersbiggsexamdtls] 
            WHERE  [finalsubmit] = 'Yes' 
                   AND candidateid = @candidateid 

DELETE FROM [dbo].[trecruitmyersbriggscandidatedtls] 
            WHERE [quesfinalsubmit]  IS NULL 
                   AND candidateid = @candidateid 

DELETE FROM [dbo].[trecruitmyersbiggsexamdtls] 
            WHERE  [finalsubmit] = 'No' 
            AND candidateid = @candidateid 
INSERT INTO [dbo].[trecruitmyersbiggsexamdtls] 
                        ([candidateid], 
                         [languageid], 
                         [totalques], 
                         [attemques], 
                         [finalsubmit], 
                         [attemexam]) 
            VALUES      ( @candidateid, 
                          @maplanid, 
                          @countexamques, 
                          NULL, 
                          'No', 
                          @attemptno + 1 )

end
if @action='myersbriggsquesansselect'
begin
SELECT previousvalue, 
                   previousvalueques, 
                   questionserialno, 
                   question, 
                   nextvalue, 
                   nextvalueques, 
                   noofques 
            FROM   (SELECT Lag(p.questionserialno) 
                             OVER ( 
                               ORDER BY p.[id]) PreviousValue, 
                           Lag(p.question) 
                             OVER ( 
                               ORDER BY p.[id]) PreviousValueques, 
                           p.questionserialno, 
                           p.question, 
                           Lead(p.questionserialno) 
                             OVER ( 
                               ORDER BY p.[id]) NextValue, 
                           Lead(p.question) 
                             OVER ( 
                               ORDER BY p.[id]) NextValueques, 
                           languageid 
                    FROM   [dbo].[trecruitmyersbriggsquesdtls] p 
                    WHERE  languageid = @maplanid 
                           AND deleteflag = 'No')s, 
                   (SELECT languageid, 
                           Count([question])noofques 
                    FROM   [dbo].[trecruitmyersbriggsquesdtls] 
                    WHERE  languageid = @maplanid 
                           AND deleteflag = 'No' 
                    GROUP  BY languageid) p 
            WHERE  questionserialno = @quesserialno 
                   AND p.languageid = s.languageid 
end
 IF @action = 'myersbriggsquesansselectnext' 
        BEGIN 
		
            SELECT previousvalue, 
                   previousvalueques, 
                   s.questionserialno, 
                   question, 
                   nextvalue, 
                   nextvalueques, 
                   noofques, 
                   CASE 
                     WHEN x.candidateid IS NULL THEN 0 
                     ELSE x.candidateid 
                   END candidateid, 
                   CASE 
                     WHEN x.[answer] IS NULL THEN '0' 
                     ELSE x.[answer] 
                   END answer, 
                   CASE 
                     WHEN y.[attemques] BETWEEN 1 AND 100 THEN y.[attemques] 
                     ELSE y.[attemques] 
                   END [attemques] 
            FROM   (SELECT Lag(p.questionserialno) 
                             OVER ( 
                               ORDER BY p.[id]) PreviousValue, 
                           Lag(p.question) 
                             OVER ( 
                               ORDER BY p.[id]) PreviousValueques, 
                           p.questionserialno, 
                           p.question, 
                           Lead(p.questionserialno) 
                             OVER ( 
                               ORDER BY p.[id]) NextValue, 
                           Lead(p.question) 
                             OVER ( 
                               ORDER BY p.[id]) NextValueques, 
                           languageid 
                    FROM   [dbo].[trecruitmyersbriggsquesdtls] p 
                    WHERE  languageid = 5 
                           AND deleteflag = 'No')s 
                   LEFT OUTER JOIN 
                   --[dbo].[trecruitmyersbriggscandidatedtls] 
				   (Select questionserialno,languageid,candidateid,
                    answer=STUFF
                   (
                      (
                        Select distinct ','+CAST(answer as varchar)
	                    from [trecruitmyersbriggscandidatedtls] t2
	                    where t1.questionserialno=t2.questionserialno
	                    
	                    and candidateid=@candidateid
						and [quesfinalsubmit]  IS NULL
	                    FOR XML PATH('')
                      ),1,1,''
                   )
                   from [trecruitmyersbriggscandidatedtls]t1
                   where questionserialno=@quesserialnonext  and candidateid=@candidateid and [quesfinalsubmit]  IS NULL
                   group by questionserialno,languageid,candidateid)x 
                   
                                ON s.languageid = x.[languageid] 
                                   AND s.questionserialno = x.[questionserialno] ,
                                  -- AND [quesfinalsubmit]  IS NULL 
                                  -- AND x.[candidateid] = @candidateid, 
                   (SELECT languageid, 
                           Count([question])noofques 
                    FROM   [dbo].[trecruitmyersbriggsquesdtls] 
                    WHERE  languageid = @maplanid 
                           AND deleteflag = 'No' 
                    GROUP  BY languageid) p, 
                   [dbo].[trecruitmyersbiggsexamdtls] y 
            WHERE  s.questionserialno= @quesserialnonext 
                   AND p.languageid = s.languageid 
                   AND s.languageid = y.[languageid] 
                   AND y.[candidateid] = @candidateid 
                   AND [finalsubmit] <> 'Yes' 
        END 

IF @action = 'myersbriggscandtlsinsert' 
         AND @findques = 0 
        BEGIN 
		    Declare @anstbl table(id int identity,answer varchar(10))
			Declare @anstablerowcount int
			Declare @count int=1
			Declare @givensingleans int
			insert into @anstbl
			(
			 answer
			)
			Select * from dbo.Split(@number,',')
            SELECT @countexamattm = [attemexam] 
            FROM   [dbo].[trecruitmyersbiggsexamdtls] 
            WHERE  [candidateid] = @candidateid 
                   AND finalsubmit <> 'Yes' 

            SELECT @countexamattmcan = Count([candidateid]) 
            FROM   [dbo].[trecruitmyersbiggsexamdtls] 
            WHERE  [candidateid] = @candidateid 
			Select @anstablerowcount=COUNT(id) from @anstbl
			while(@count <=@anstablerowcount)
            BEGIN 
			   Select @givensingleans=CAST(answer as int )from @anstbl where id=@count
                INSERT INTO [dbo].[trecruitmyersbriggscandidatedtls] 
                            ([candidateid], 
                             [languageid], 
                             [questionserialno], 
                             [answer], 
                             candidateattemexam, 
                             [createdon], 
                             [updatedon]) 
                VALUES      ( @candidateid, 
                              @maplanid, 
                              @questiondtlsid, 
                              @givensingleans, 
                              @countexamattm, 
                              Getdate(), 
                              Getdate() ) 

                SET @message='Answer Details Successfully Inserted' 
				Set @count=@count + 1
            END 

            SELECT @countexamattques = Count(distinct[questionserialno]) 
            FROM   [dbo].[trecruitmyersbriggscandidatedtls] 
            WHERE  candidateid = @candidateid 
                   AND answer <> 0 
                   AND quesfinalsubmit IS NULL 

            IF @countexamattm IS NOT NULL 
              BEGIN 
                  UPDATE [dbo].[trecruitmyersbiggsexamdtls] 
                  SET    [attemques] = [totalques] - @countexamattques 
                  WHERE  candidateid = @candidateid 
                         AND finalsubmit <> 'Yes' 
              END 
        END 
 IF @action = 'myersbriggscandtlsinsert' 
         AND @findques > 0 
        BEGIN 
		    Delete from [dbo].[trecruitmyersbriggscandidatedtls] 
			WHERE  [candidateid] = @candidateid 
            AND [questionserialno] = @questiondtlsid 
            AND [quesfinalsubmit] IS NULL 
			Declare @anstbl1 table(id int identity,answer varchar(10))
			Declare @anstablerowcount1 int
			Declare @count1 int=1
			Declare @givensingleans1 int
			insert into @anstbl1
			(
			 answer
			)
			Select * from dbo.Split(@number,',')
            SELECT @countexamattm = [attemexam] 
            FROM   [dbo].[trecruitmyersbiggsexamdtls] 
            WHERE  [candidateid] = @candidateid 
            
			       AND finalsubmit <> 'Yes' 

            --UPDATE [dbo].[trecruitmyersbriggscandidatedtls] 
            --SET    [answer] = @number, 
            --       [updatedon] = Getdate() 
            --WHERE  [candidateid] = @candidateid 
            --       AND [questionserialno] = @questiondtlsid 
            --       AND [quesfinalsubmit] IS NULL 

            Select @anstablerowcount1=COUNT(id) from @anstbl1
			while(@count1 <=@anstablerowcount1)
            BEGIN 
			   Select @givensingleans1=CAST(answer as int )from @anstbl1 where id=@count1
                INSERT INTO [dbo].[trecruitmyersbriggscandidatedtls] 
                            ([candidateid], 
                             [languageid], 
                             [questionserialno], 
                             [answer], 
                             candidateattemexam, 
                             [createdon], 
                             [updatedon]) 
                VALUES      ( @candidateid, 
                              @maplanid, 
                              @questiondtlsid, 
                              @givensingleans1, 
                              @countexamattm, 
                              Getdate(), 
                              Getdate() ) 

                SET @message='Answer Details Successfully Inserted' 
				Set @count1=@count1 + 1
            END 

            SELECT @countexamattques = Count(distinct[questionserialno]) 
            FROM   [dbo].[trecruitmyersbriggscandidatedtls] 
            WHERE  candidateid = @candidateid 
                   AND answer <> 0 
                   AND quesfinalsubmit IS NULL 

            IF @countexamattm IS NOT NULL 
              BEGIN 
                  UPDATE [dbo].[trecruitmyersbiggsexamdtls] 
                  SET    [attemques] = [totalques] - @countexamattques 
                  WHERE  candidateid = @candidateid 
                         AND finalsubmit <> 'Yes' 
              END 
        END 
 IF @action = 'myersbriggsansqnoselect' 
        BEGIN 
            SELECT @atteptestno = [attemexam] 
            FROM   [dbo].[trecruitmyersbiggsexamdtls] 
            WHERE  [finalsubmit] <> 'Yes' 
                   AND [candidateid] = @candidateid 

            SELECT [questionserialno] 
            FROM   [dbo].[trecruitmyersbriggscandidatedtls] 
            WHERE  [answer] > 0 
                   AND [candidateattemexam] = @atteptestno 
                   AND [candidateid] = @candidateid 
        END 
 IF @action='myersbriggsansselect'
 begin
  Select answerno,answer from [dbo].[trecruitmyersbriggsanswer]
  where questionno=@quesserialnonext
  
 end
 IF @action='myersbriggsfirstquesansselect'
 begin
  Select answerno,answer from [dbo].[trecruitmyersbriggsanswer]
  where questionno=1
  
 end
  IF @action = 'Finalsubmit' 
        BEGIN 
            UPDATE [dbo].[trecruitmyersbiggsexamdtls] 
            SET    [finalsubmit] = 'Yes' 
            WHERE  candidateid = @candidateid 

            --UPDATE [dbo].[trecruittraker] 
            --SET    [conflictallow] = 'Completed' 
            --WHERE  candidateid = @candidateid 

			---------------------------------------
			UPDATE [dbo].[trecruitcanbasicdtls] 
            SET    [myersbriggsallow] = 'Completed' 
            WHERE  candidateid = @candidateid 
			-------------------------------------------

            UPDATE [dbo].[trecruitmyersbriggscandidatedtls] 
            SET    [quesfinalsubmit] = 'F' 
            WHERE  candidateid = @candidateid 

		

	--		select @discrolfinalsubmit=[finalsubmit],@discrolattemexam=[attemexam]
	--		 from [dbo].[trecruitdiscrolexamdtls]
	--		where [candidateid]=@candidateid 

	--		select @conflictfinalsubmit=[finalsubmit],@conflictattemexam=[attemexam]
	--		 from [dbo].[trecruitconflictexamdtls]
	--		where [candidateid]=@candidateid 

	--		if @discrolfinalsubmit='Yes' and @conflictfinalsubmit='Yes'
	--		and @discrolattemexam<2 and @conflictattemexam<2
	--		begin


 --  SELECT @MailId=[MailId]      
 -- FROM [dbo].[trecruitcandidatesignup]
 -- where candidateid=@candidateid

	--EXEC msdb.dbo.sp_send_dbmail
 --   @profile_name = 'Mendine2_Email_Profile'
 --  ,@recipients = @MailId
 --  ,@subject = 'Email from SQL Server'
 --  ,@body = 'This is my First Email sent from SQL Server :)'
 --  ,@importance ='HIGH'
	--		end
        END 
end
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: trecruitcanbasicdtls, trecruitmyersbriggscandidatedtls */
/****** Object:  StoredProcedure [dbo].[procmyersbriggsresult]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[procmyersbriggsresult]
@candidateattemexam INT=NULL,
@registrationnumber VARCHAR(200)=NULL
as
Declare @cangender varchar(20)
Declare @candidateid int
Declare @Escore int
Declare @Iscore int
Declare @Sscore int
Declare @Nscore int
Declare @Tscore int
Declare @Fscore int
Declare @Jscore int
Declare @Pscore int
Declare @EorI varchar(10)
Declare @SorN varchar(10)
Declare @TorF varchar(10)
Declare @JorP varchar(10)
begin
 SELECT @candidateid = candidateid,@cangender=gender 
      FROM   [dbo].[trecruitcanbasicdtls] 
      WHERE  registrationnumber = @registrationnumber 
---------------@Escore Calculation-----------------------------
Select @Escore=sum(score) from
(

select questionserialno,answer,
case 
  when questionserialno=3 and (answer =1  ) then 2
  when questionserialno=6 and (answer =1) then 2
  when questionserialno=9 and (answer =1 ) then 2
  when questionserialno=13 and (answer =1 ) then 1
  when questionserialno=16 and (answer =1 ) then 2
  when questionserialno=21 and (answer =1 ) then 2
  when questionserialno=24 and (answer =1 ) then 1
  when questionserialno=26 and (answer =1 ) then 1
  when questionserialno=29 and (answer =2 ) then 2
  when questionserialno=36 and (answer =2 ) then 2
  when questionserialno=43 and (answer =2 ) then 1
  
  
  else 0
  end score
from trecruitmyersbriggscandidatedtls 
where candidateid=@candidateid 
and candidateattemexam=@candidateattemexam
and questionserialno in(3,6,9,13,16,21,24,2629,36,43))a
---------------End of @Escore Calculation-----------------------------
---------------@Iscore Calculation-----------------------------
Select @Iscore=sum(score) from
(

select questionserialno,answer,
case 
  when questionserialno=3 and (answer =2  ) then 2
  when questionserialno=6 and (answer =2) then 1
  when questionserialno=9 and (answer =2 ) then 1
  when questionserialno=13 and (answer =2 ) then 2
  when questionserialno=16 and (answer =2 ) then 2
  when questionserialno=21 and (answer =2 ) then 2
  when questionserialno=24 and (answer =2 ) then 1
  when questionserialno=26 and (answer =2 ) then 0
  when questionserialno=29 and (answer =1 ) then 2
  when questionserialno=36 and (answer =1 ) then 1
  when questionserialno=43 and (answer =1 ) then 1
  
  
  
  else 0
  end score
from trecruitmyersbriggscandidatedtls 
where candidateid=@candidateid 
and candidateattemexam=@candidateattemexam
and questionserialno in(3,6,9,13,16,21,24,26,29,36,43))a
---------------End of @Iscore Calculation-----------------------------

---------------@Sscore Calculation-----------------------------
Select @Sscore=sum(score) from
(

select questionserialno,answer,
case 
  when questionserialno=2 and (answer =1  ) then 2
  when questionserialno=5 and (answer =2  ) then 1
  when questionserialno=10 and (answer =1  ) then 1
  when questionserialno=12 and (answer =1  ) then 1
  when questionserialno=15 and (answer =2  ) then 1
  when questionserialno=20 and (answer =1  ) then 2
  when questionserialno=23 and (answer =2  ) then 2 
  when questionserialno=28 and (answer =1  ) then 2 
  when questionserialno=31 and (answer =2  ) then 2
  when questionserialno=35 and (answer =1  ) then 2 
  when questionserialno=38 and (answer =2  ) then 2  
  when questionserialno=42 and (answer =1  ) then 1
  when questionserialno=45 and (answer =2  ) then 2  
  when questionserialno=48 and (answer =1  ) then 1  
  
  else 0
  end score
from trecruitmyersbriggscandidatedtls 
where candidateid=@candidateid 
and candidateattemexam=@candidateattemexam
and questionserialno in(2,5,10,12,15,20,23,28,31,35,38,42,45,48))a
---------------End of @Sscore Calculation-----------------------------
---------------@Nscore Calculation-----------------------------
Select @Nscore=sum(score) from
(

select questionserialno,answer,
case 
  when questionserialno=2 and (answer =2  ) then 2
  when questionserialno=5 and (answer =1  ) then 1
  when questionserialno=10 and (answer =2  ) then 2
  when questionserialno=12 and (answer =2  ) then 2
  when questionserialno=15 and (answer =1  ) then 0
  when questionserialno=20 and (answer =2  ) then 2
  when questionserialno=23 and (answer =1  ) then 1 
  when questionserialno=28 and (answer =2  ) then 1 
  when questionserialno=31 and (answer =1  ) then 0
  when questionserialno=35 and (answer =2  ) then 1 
  when questionserialno=38 and (answer =1  ) then 0  
  when questionserialno=42 and (answer =2  ) then 2
  when questionserialno=45 and (answer =1  ) then 0  
  when questionserialno=48 and (answer =2  ) then 1  
  
  else 0
  end score
from trecruitmyersbriggscandidatedtls 
where candidateid=@candidateid 
and candidateattemexam=@candidateattemexam
and questionserialno in(2,5,10,12,15,20,23,28,31,35,38,42,45,48))a
---------------End of @Nscore Calculation-----------------------------

---------------@Tscore Calculation-----------------------------
Select @Tscore=sum(score) from
(

select questionserialno,answer,
case 
  
   when questionserialno= 4 and (answer =2  )then	2
   when questionserialno=14 and (answer =2  )then	2
   when questionserialno=22 and (answer =2  )then	2
   when questionserialno=30 and (answer =1  )then	2
   when questionserialno=32 and (answer =1  )then	1
   when questionserialno=33 and (answer =2  )then	2
   when questionserialno=37 and (answer =1  )then	1
   when questionserialno=39 and (answer =1  )then	1
   when questionserialno=40 and (answer =2  )then	2
   when questionserialno=44 and (answer =1  )then	1
   when questionserialno=46 and (answer =1  )then	2
   when questionserialno=47 and (answer =2  )then	2
   when questionserialno=49 and (answer =1  )then	2
   when questionserialno=50 and (answer =1  )then	2
  
  
  else 0
  end score
from trecruitmyersbriggscandidatedtls 
where candidateid=@candidateid 
and candidateattemexam=@candidateattemexam
and questionserialno in(4,14,22,30,32,33,37,39,40,44,46,47,49,50))a
---------------End of @Tscore Calculation-----------------------------

---------------@Fscore Calculation-----------------------------
Select @Fscore=sum(score) from
(

select questionserialno,answer,
case 
  
   
   When questionserialno=4 and (answer =1  )then	1
   When questionserialno=14 and (answer =1  )then	1
   When questionserialno=22 and (answer =1  )then	2
   When questionserialno=30 and (answer =2  ) then	1
   When questionserialno=32 and (answer =2  ) then	1
   When questionserialno=33 and (answer =1  )then	0
   When questionserialno=37 and (answer =2  ) then	2
   When questionserialno=39 and (answer =2  ) then	1
   When questionserialno=40 and (answer =1  ) then	1
   When questionserialno=44 and (answer =2  ) then	2
   When questionserialno=46 and (answer =2  ) then	0
   When questionserialno=47 and (answer =1  ) then	1
   When questionserialno=49 and (answer =2  ) then	1
   When questionserialno=50 and (answer =2  ) then	0
     
  
  else 0
  end score
from trecruitmyersbriggscandidatedtls 
where candidateid=@candidateid 
and candidateattemexam=@candidateattemexam
and questionserialno in(4,14,22,30,32,33,37,39,40,44,46,47,49,50))a
---------------End of @Fscore Calculation-----------------------------

---------------@Jscore Calculation-----------------------------
Select @Jscore=sum(score) from
(

select questionserialno,answer,
case 
  
   
   
   When questionserialno=1 and (answer =1  ) then	2
   When questionserialno=7 and (answer =1  ) then	1
   When questionserialno=8 and (answer =1  ) then	1
   When questionserialno=11 and (answer =1  )then	2
   When questionserialno=17 and (answer =1  )then	2
   When questionserialno=18 and (answer =1  )then	1
   When questionserialno=19 and (answer =1  )then	1
   When questionserialno=25 and (answer =1  )then	1
   When questionserialno=25 and (answer =3  )then	0
   When questionserialno=27 and (answer =1  )then	2
   When questionserialno=34 and (answer =1  )then	2
   When questionserialno=41 and (answer =1  )then	2
     
  
  else 0
  end score
from trecruitmyersbriggscandidatedtls 
where candidateid=@candidateid 
and candidateattemexam=@candidateattemexam
and questionserialno in(1,7,8,11,17,18,19,25,27,34,41))a
---------------End of @Jscore Calculation-----------------------------

---------------@Pscore Calculation-----------------------------
Select @Pscore=sum(score) from
(

select questionserialno,answer,
case 
   When questionserialno=   1 and (answer =2  )then	2
   When questionserialno=7 and (answer =2  )then	1
   When questionserialno=7 and (answer =3  )then	1
   When questionserialno=8 and (answer =2  )then	2
   When questionserialno=11 and (answer =2  )then	1
   When questionserialno=17 and (answer =2  )then	2
   When questionserialno=18 and (answer =2  )then	1
   When questionserialno=19 and (answer =2  )then	1
   When questionserialno=25 and (answer =2  )then	1
   When questionserialno=27 and (answer =2  )then	2
   When questionserialno=34 and (answer =2  )then	2
   When questionserialno=41 and (answer =2  )then	2

     
  
  else 0
  end score
from trecruitmyersbriggscandidatedtls 
where candidateid=@candidateid 
and candidateattemexam=@candidateattemexam
and questionserialno in(1,7,8,11,17,18,19,25,27,34,41))a
---------------End of @Pscore Calculation-----------------------------
--Select  @Escore Escore,
-- @Iscore Iscore,
-- @Sscore Sscore,
-- @Nscore Nscore,
-- @Tscore Tscore,
-- @Fscore Fscore,
-- @Jscore Jscore,
-- @Pscore Pscore
--------E or I------------------------
 if(@Escore > @Iscore )
 begin
  Set @EorI='E'
 end
 else
 begin
   if(@Escore = @Iscore)
   begin
    Set @EorI='I'
   end
   else
   begin 
    Set @EorI='I'
   end
 end
 --------End of E or I------------------------
 --------S or N------------------------
 if(@Sscore > @Nscore )
 begin
  Set @SorN='S'
 end
 else
 begin
   if(@Sscore = @Nscore)
   begin
    Set @SorN='N'
   end
   else
   begin 
    Set @SorN='N'
   end
 end
 --------End of S or N------------------------
 --------T or F------------------------
 if(@Tscore > @Fscore )
 begin
  Set @TorF='T'
 end
 else if(@Tscore = @Fscore)
 begin
  if(@cangender ='Male')
  begin
   Set @TorF='T'
  end
  else
  begin
    Set @TorF='F'
  end
 end
 else
   begin 
    Set @TorF='F'
   end
 
 --------End of T or F------------------------
  --------J or P------------------------
 if(@Jscore > @Pscore )
 begin
  Set @JorP='J'
 end
 else
 begin
   if(@Jscore = @Pscore)
   begin
    Set @JorP='P'
   end
   else
   begin 
    Set @JorP='P'
   end
 end
 --------End of S or N------------------------
 Select @EorI EorI,@SorN SorN,@TorF TorF,@JorP JorP
end
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: trecruitcanbasicdtls, trecruitrotterlocusofcontrolexamdtls, trecruittraker */
/****** Object:  StoredProcedure [dbo].[procrotterlocusofcontrolhrdtls]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[procrotterlocusofcontrolhrdtls]
@candidateattemexam INT=NULL, 
@registrationnumber VARCHAR(200)=NULL,
@action varchar(200),
@Message            VARCHAR(200)=NULL 
as
declare @candidateid int
declare @canrotterlocusofcontrolallow varchar(100)

begin
SELECT @candidateid = candidateid 
      FROM   [dbo].[trecruitcanbasicdtls] 
      WHERE  registrationnumber = @registrationnumber 
IF @action = 'SELECTEXAMNO' 
        BEGIN 
            SELECT [attemexam], 
                   CASE 
                     WHEN [attemexam] = 1 THEN Cast('1st Exam' AS VARCHAR) 
                     WHEN [attemexam] = 2 THEN Cast('2nd Exam'AS VARCHAR) 
                     WHEN [attemexam] = 3 THEN Cast('3rd Exam'AS VARCHAR) 
                     ELSE Cast([attemexam]AS VARCHAR) + '' + 'th Exam' 
                   END [attemexamtext] 
            FROM   trecruitrotterlocusofcontrolexamdtls
            WHERE  candidateid = @candidateid 
                   AND finalsubmit = 'Yes' 
            ORDER  BY [attemexam] 
        END 
IF @action = 'Activeinactiveresbutton' 
        BEGIN 
            SELECT 
                   a.[rotterlocusofcontrolallow] 
            FROM   [dbo].[trecruitcanbasicdtls] a                
            WHERE a.candidateid = @candidateid 
        END 
  IF @action = 'Reschedule' 
        BEGIN 
            --SELECT @candiscrolallow = [discrolallow] 
            --FROM   [trecruittraker] 
            --WHERE  [candidateid] = @candidateid 
            --GROUP  BY [discrolallow], 
            --          [conflictallow], 
            --          [iqallow], 
            --          [eqallow] 

			SELECT @canrotterlocusofcontrolallow = [rotterlocusofcontrolallow] 
            FROM   [trecruitcanbasicdtls]
            WHERE  [candidateid] = @candidateid 
            --GROUP  BY [discrolallow], 
            --          [conflictallow], 
            --          [iqallow], 
            --          [eqallow] 

             
            IF @canrotterlocusofcontrolallow = 'Completed' 
              BEGIN 
                  UPDATE [trecruitcanbasicdtls] 
                  SET    [rotterlocusofcontrolallow] = 'Reschedule' 
                  WHERE  [candidateid] = @candidateid 
              END 
            ELSE 
              BEGIN 
                  SET @message=1 
              END 
        END
end
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: trecruitcanbasicdtls, trecruitcandidatesignup, trecruitconflictexamdtls, trecruitdiscrolexamdtls, trecruitrotterlocusofcontrolanswer, trecruitrotterlocusofcontrolcandidatedtls, trecruitrotterlocusofcontrolcanlanguagemapping, trecruitrotterlocusofcontrolexamdtls, trecruitrotterlocusofcontrolquesdtls, trecruittraker */
/****** Object:  StoredProcedure [dbo].[procrotterlocusofcontrolmasdtls]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[procrotterlocusofcontrolmasdtls]
@username varchar(Max),
@action varchar(Max),
@questiondtlsid   INT=NULL,
@number int=null,
@quesserialnonext int=null,
@message VARCHAR(500)=NULL output 
as
declare @candidateid int
declare @maplanid int
declare @countexamques int
declare @attemptno int
declare @quesserialno int
declare @findques int
declare @countexamattm int
declare @countexamattmcan int
declare @countexamattques int
declare @atteptestno int
begin
SELECT @candidateid = candidateid 
      FROM   [trecruitcandidatesignup] 
      WHERE  [username] = @username 
SELECT @maplanid = languageid 
            FROM   [trecruitrotterlocusofcontrolcanlanguagemapping] 
            WHERE  candidateid = @candidateid 
SELECT @quesserialno = Min(questionserialno) 
      FROM   [trecruitrotterlocusofcontrolquesdtls] 
      WHERE  languageid = @maplanid 
             AND deleteflag = 'No' 
SELECT @findques = Count(questionserialno) 
      FROM   [trecruitrotterlocusofcontrolcandidatedtls] 
      WHERE  candidateid = @candidateid 
             AND questionserialno = @questiondtlsid 
             AND [quesfinalsubmit] IS NULL 

if(@action ='rotterlocusofcontrolcandidatelanguagemap')
begin
 DELETE FROM [dbo].[trecruitrotterlocusofcontrolcanlanguagemapping] 
            WHERE  [candidateid] = @candidateid 

            INSERT INTO [dbo].[trecruitrotterlocusofcontrolcanlanguagemapping] 
                        ([candidateid], 
                         [languageid]) 
            VALUES      (@candidateid, 
                         5 ) 
SELECT @maplanid = languageid 
            FROM   [trecruitrotterlocusofcontrolcanlanguagemapping] 
            WHERE  candidateid = @candidateid 
 SELECT @countexamques = Count([questionserialno]) 
            FROM   [trecruitrotterlocusofcontrolquesdtls] 
            WHERE  [languageid] = @maplanid 
SELECT @attemptno = Count([attemexam]) 
            FROM   [trecruitrotterlocusofcontrolexamdtls] 
            WHERE  [finalsubmit] = 'Yes' 
                   AND candidateid = @candidateid 

DELETE FROM [trecruitrotterlocusofcontrolcandidatedtls] 
            WHERE [quesfinalsubmit]  IS NULL 
                   AND candidateid = @candidateid 

DELETE FROM [trecruitrotterlocusofcontrolexamdtls] 
            WHERE  [finalsubmit] = 'No' 
            AND candidateid = @candidateid 
INSERT INTO [trecruitrotterlocusofcontrolexamdtls] 
                        ([candidateid], 
                         [languageid], 
                         [totalques], 
                         [attemques], 
                         [finalsubmit], 
                         [attemexam]) 
            VALUES      ( @candidateid, 
                          @maplanid, 
                          @countexamques, 
                          NULL, 
                          'No', 
                          @attemptno + 1 )

end
if @action='rotterlocusofcontrolquesansselect'
begin
SELECT previousvalue, 
                   previousvalueques, 
                   questionserialno, 
                   question, 
                   nextvalue, 
                   nextvalueques, 
                   noofques 
            FROM   (SELECT Lag(p.questionserialno) 
                             OVER ( 
                               ORDER BY p.[id]) PreviousValue, 
                           Lag(p.question) 
                             OVER ( 
                               ORDER BY p.[id]) PreviousValueques, 
                           p.questionserialno, 
                           p.question, 
                           Lead(p.questionserialno) 
                             OVER ( 
                               ORDER BY p.[id]) NextValue, 
                           Lead(p.question) 
                             OVER ( 
                               ORDER BY p.[id]) NextValueques, 
                           languageid 
                    FROM   [trecruitrotterlocusofcontrolquesdtls] p 
                    WHERE  languageid = @maplanid 
                           AND deleteflag = 'No')s, 
                   (SELECT languageid, 
                           Count([question])noofques 
                    FROM   [trecruitrotterlocusofcontrolquesdtls] 
                    WHERE  languageid = @maplanid 
                           AND deleteflag = 'No' 
                    GROUP  BY languageid) p 
            WHERE  questionserialno = @quesserialno 
                   AND p.languageid = s.languageid 
end
 IF @action = 'rotterlocusofcontrolquesansselectnext' 
        BEGIN 
		
            SELECT previousvalue, 
                   previousvalueques, 
                   s.questionserialno, 
                   question, 
                   nextvalue, 
                   nextvalueques, 
                   noofques, 
                   CASE 
                     WHEN x.candidateid IS NULL THEN 0 
                     ELSE x.candidateid 
                   END candidateid, 
                   CASE 
                     WHEN x.[answer] IS NULL THEN 0 
                     ELSE x.[answer] 
                   END answer, 
                   CASE 
                     WHEN y.[attemques] BETWEEN 1 AND 100 THEN y.[attemques] 
                     ELSE y.[attemques] 
                   END [attemques] 
            FROM   (SELECT Lag(p.questionserialno) 
                             OVER ( 
                               ORDER BY p.[id]) PreviousValue, 
                           Lag(p.question) 
                             OVER ( 
                               ORDER BY p.[id]) PreviousValueques, 
                           p.questionserialno, 
                           p.question, 
                           Lead(p.questionserialno) 
                             OVER ( 
                               ORDER BY p.[id]) NextValue, 
                           Lead(p.question) 
                             OVER ( 
                               ORDER BY p.[id]) NextValueques, 
                           languageid 
                    FROM   [trecruitrotterlocusofcontrolquesdtls] p 
                    WHERE  languageid = 5 
                           AND deleteflag = 'No')s 
                   LEFT OUTER JOIN 
                   [trecruitrotterlocusofcontrolcandidatedtls] 
                   x 
                                ON s.languageid = x.[languageid] 
                                   AND s.questionserialno = x.[questionserialno] 
                                   AND [quesfinalsubmit]  IS NULL 
                                   AND x.[candidateid] = @candidateid, 
                   (SELECT languageid, 
                           Count([question])noofques 
                    FROM   [trecruitrotterlocusofcontrolquesdtls] 
                    WHERE  languageid = @maplanid 
                           AND deleteflag = 'No' 
                    GROUP  BY languageid) p, 
                   [trecruitrotterlocusofcontrolexamdtls] y 
            WHERE  s.questionserialno= @quesserialnonext 
                   AND p.languageid = s.languageid 
                   AND s.languageid = y.[languageid] 
                   AND y.[candidateid] = @candidateid 
                   AND [finalsubmit] <> 'Yes' 
        END 

IF @action = 'rotterlocusofcontrolcandtlsinsert' 
         AND @findques = 0 
        BEGIN 
            SELECT @countexamattm = [attemexam] 
            FROM   [trecruitrotterlocusofcontrolexamdtls] 
            WHERE  [candidateid] = @candidateid 
                   AND finalsubmit <> 'Yes' 

            SELECT @countexamattmcan = Count([candidateid]) 
            FROM   [trecruitrotterlocusofcontrolexamdtls] 
            WHERE  [candidateid] = @candidateid 

            BEGIN 
                INSERT INTO [trecruitrotterlocusofcontrolcandidatedtls] 
                            ([candidateid], 
                             [languageid], 
                             [questionserialno], 
                             [answer], 
                             candidateattemexam, 
                             [createdon], 
                             [updatedon]) 
                VALUES      ( @candidateid, 
                              @maplanid, 
                              @questiondtlsid, 
                              @number, 
                              @countexamattm, 
                              Getdate(), 
                              Getdate() ) 

                SET @message='Answer Details Successfully Inserted' 
            END 

            SELECT @countexamattques = Count([questionserialno]) 
            FROM   [trecruitrotterlocusofcontrolcandidatedtls] 
            WHERE  candidateid = @candidateid 
                   AND answer <> 0 
                   AND quesfinalsubmit IS NULL 

            IF @countexamattm IS NOT NULL 
              BEGIN 
                  UPDATE [trecruitrotterlocusofcontrolexamdtls] 
                  SET    [attemques] = [totalques] - @countexamattques 
                  WHERE  candidateid = @candidateid 
                         AND finalsubmit <> 'Yes' 
              END 
        END 
 IF @action = 'rotterlocusofcontrolcandtlsinsert' 
         AND @findques > 0 
        BEGIN 
            SELECT @countexamattm = [attemexam] 
            FROM   [trecruitrotterlocusofcontrolexamdtls] 
            WHERE  [candidateid] = @candidateid 
                   AND finalsubmit <> 'Yes' 

            UPDATE [trecruitrotterlocusofcontrolcandidatedtls] 
            SET    [answer] = @number, 
                   [updatedon] = Getdate() 
            WHERE  [candidateid] = @candidateid 
                   AND [questionserialno] = @questiondtlsid 
                   AND [quesfinalsubmit] IS NULL 

            SET @message='Answer Details Successfully Updated' 

            SELECT @countexamattques = Count([questionserialno]) 
            FROM   [trecruitrotterlocusofcontrolcandidatedtls] 
            WHERE  candidateid = @candidateid 
                   AND answer <> 0 
                   AND quesfinalsubmit IS NULL 

            IF @countexamattm IS NOT NULL 
              BEGIN 
                  UPDATE [trecruitrotterlocusofcontrolexamdtls] 
                  SET    [attemques] = [totalques] - @countexamattques 
                  WHERE  candidateid = @candidateid 
                         AND finalsubmit <> 'Yes' 
              END 
        END 
 IF @action = 'rotterlocusofcontrolansqnoselect' 
        BEGIN 
            SELECT @atteptestno = [attemexam] 
            FROM   [trecruitrotterlocusofcontrolexamdtls] 
            WHERE  [finalsubmit] <> 'Yes' 
                   AND [candidateid] = @candidateid 

            SELECT [questionserialno] 
            FROM   [trecruitrotterlocusofcontrolcandidatedtls] 
            WHERE  [answer] > 0 
                   AND [candidateattemexam] = @atteptestno 
                   AND [candidateid] = @candidateid 
        END 
  IF @action='rotterlocusofcontrolansselect'
 begin
  Select answerno,answer from trecruitrotterlocusofcontrolanswer
  where questionno=@quesserialnonext
  
 end
 IF @action='rotterlocusofcontrolfirstquesansselect'
 begin
  Select answerno,answer from trecruitrotterlocusofcontrolanswer
  where questionno=1
  
 end
  IF @action = 'Finalsubmit' 
        BEGIN 
            UPDATE [trecruitrotterlocusofcontrolexamdtls] 
            SET    [finalsubmit] = 'Yes' 
            WHERE  candidateid = @candidateid 

            --UPDATE [trecruittraker] 
            --SET    [conflictallow] = 'Completed' 
            --WHERE  candidateid = @candidateid 

			---------------------------------------
			UPDATE [trecruitcanbasicdtls] 
            SET    [rotterlocusofcontrolallow] = 'Completed' 
            WHERE  candidateid = @candidateid 
			-------------------------------------------

            UPDATE [dbo].[trecruitrotterlocusofcontrolcandidatedtls] 
            SET    [quesfinalsubmit] = 'F' 
            WHERE  candidateid = @candidateid 

		

	--		select @discrolfinalsubmit=[finalsubmit],@discrolattemexam=[attemexam]
	--		 from [trecruitdiscrolexamdtls]
	--		where [candidateid]=@candidateid 

	--		select @conflictfinalsubmit=[finalsubmit],@conflictattemexam=[attemexam]
	--		 from [trecruitconflictexamdtls]
	--		where [candidateid]=@candidateid 

	--		if @discrolfinalsubmit='Yes' and @conflictfinalsubmit='Yes'
	--		and @discrolattemexam<2 and @conflictattemexam<2
	--		begin


 --  SELECT @MailId=[MailId]      
 -- FROM [trecruitcandidatesignup]
 -- where candidateid=@candidateid

	--EXEC msdb.dbo.sp_send_dbmail
 --   @profile_name = 'Mendine2_Email_Profile'
 --  ,@recipients = @MailId
 --  ,@subject = 'Email from SQL Server'
 --  ,@body = 'This is my First Email sent from SQL Server :)'
 --  ,@importance ='HIGH'
	--		end
        END 
end
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: trecruitcanbasicdtls, trecruitrotterlocusofcontrolcandidatedtls */
/****** Object:  StoredProcedure [dbo].[procrotterlocusofcontrolresult]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[procrotterlocusofcontrolresult]
@candidateattemexam INT=NULL,
@registrationnumber VARCHAR(200)=NULL
as
Declare @candidateid int
Declare @score int
begin
SELECT @candidateid = candidateid 
      FROM   [dbo].[trecruitcanbasicdtls] 
      WHERE  registrationnumber = @registrationnumber 

Select @score=sum(score) from
(

select questionserialno,answer,
case 
  when questionserialno=2 and answer =1  then 1
  when questionserialno=3 and answer =2  then 1
  when questionserialno=4 and answer =2  then 1
  when questionserialno=5 and answer =2  then 1
  when questionserialno=6 and answer =1  then 1
  when questionserialno=7 and answer =1  then 1
  when questionserialno=9 and answer =1  then 1
  when questionserialno=10 and answer =2  then 1
  when questionserialno=11 and answer =2  then 1
  when questionserialno=12 and answer =2  then 1
  when questionserialno=13 and answer =2  then 1
  when questionserialno=15 and answer =2  then 1
  when questionserialno=16 and answer =1  then 1
  when questionserialno=17 and answer =1  then 1
  when questionserialno=18 and answer =1  then 1
  when questionserialno=20 and answer =1  then 1
  when questionserialno=21 and answer =1  then 1
  when questionserialno=22 and answer =2  then 1
  when questionserialno=23 and answer =1  then 1
  when questionserialno=25 and answer =1  then 1
  when questionserialno=26 and answer =2  then 1
  when questionserialno=28 and answer =2  then 1
  when questionserialno=29 and answer =1  then 1


  
  else 0
end score
from trecruitrotterlocusofcontrolcandidatedtls 
where candidateid=@candidateid 
and candidateattemexam=@candidateattemexam
and questionserialno in(2,3,4,5,6,7,9,10,11,12,13,15,16,17,18,20,21,22,23,25,26,28,29))a
Select @score Score
end
GO



/* ---- TEMP / DEMO / SAMPLE / TEST / BACKUP PROCEDURES ---- */

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: tcandidateappointmentmapping, test, tofferlatterdtls, trecruitcanbasicdtls, trecruitcandidatesignup, trecruitconflictexamdtls, trecruitdiscrolexamdtls, trecruiteqexamdtls, trecruitiqexamdtls */
/****** Object:  StoredProcedure [dbo].[PRC_Sync_Data_Candidate_Detail_Test]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PRC_Sync_Data_Candidate_Detail_Test]
(
    @IDCandidate BIGINT
)
AS
BEGIN
    SET NOCOUNT ON;

    /*=====================================
      TEMP TABLE : TEST RESULT
    =====================================*/
    SELECT *
    INTO #TempTestResult
    FROM
    (
        SELECT
            a.CandidateId,

            CASE 
                WHEN a.AttemExam IS NULL OR a.AttemExam = '' THEN 0 
                ELSE a.AttemExam 
            END AS DiscrolExamNo,

            CASE 
                WHEN b.AttemExam IS NULL OR b.AttemExam = '' THEN 0 
                ELSE b.AttemExam 
            END AS EqExamNo,

            CASE 
                WHEN c.AttemExam IS NULL OR c.AttemExam = '' THEN 0 
                ELSE c.AttemExam 
            END AS ConflictExamNo,

            CASE 
                WHEN d.AttemExam IS NULL OR d.AttemExam = '' THEN 0 
                ELSE d.AttemExam 
            END AS IQExamNo

        FROM
        (
            SELECT CandidateId, MAX(AttemExam) AS AttemExam
            FROM dbo.trecruitdiscrolexamdtls
            WHERE FinalSubmit = 'Yes'
              AND CandidateId = @IDCandidate
            GROUP BY CandidateId
        ) a

        LEFT JOIN
        (
            SELECT CandidateId, MAX(AttemExam) AS AttemExam
            FROM dbo.trecruiteqexamdtls
            WHERE FinalSubmit = 'Yes'
              AND CandidateId = @IDCandidate
            GROUP BY CandidateId
        ) b ON a.CandidateId = b.CandidateId

        LEFT JOIN
        (
            SELECT CandidateId, MAX(AttemExam) AS AttemExam
            FROM dbo.trecruitconflictexamdtls
            WHERE FinalSubmit = 'Yes'
              AND CandidateId = @IDCandidate
            GROUP BY CandidateId
        ) c ON a.CandidateId = c.CandidateId

        LEFT JOIN
        (
            SELECT CandidateId, MAX(AttemExam) AS AttemExam
            FROM dbo.trecruitiqexamdtls
            WHERE FinalSubmit = 'Yes'
              AND CandidateId = @IDCandidate
            GROUP BY CandidateId
        ) d ON a.CandidateId = d.CandidateId
    ) T;


    /*=====================================
      TEMP TABLE : BASIC DETAILS
    =====================================*/
    SELECT *
    INTO #TempBasic
    FROM
    (
        SELECT
            a.CandidateId,
            a.RegistrationNumber,
            b.UserName
        FROM trecruitcanbasicdtls a
        INNER JOIN trecruitcandidatesignup b
            ON a.CandidateId = b.CandidateId
        WHERE a.CandidateId = @IDCandidate
    ) B;


    /*=====================================
      TEMP TABLE : OFFER / APPOINTMENT
    =====================================*/
    SELECT *
    INTO #TempOfferAppointment
    FROM
    (
        SELECT
            a.CandidateId,
            a.AppointmentLetterType,
            a.EmpNo,
            b.OfferdCompanyCode
        FROM tcandidateappointmentmapping a
        LEFT JOIN tofferlatterdtls b
            ON a.CandidateId = b.CandidateId
        WHERE a.DeleteFlag = 'No'
          AND b.DeleteFlag = 'No'
          AND a.CandidateId = @IDCandidate
    ) O;


    /*=====================================
      FINAL RESULT
    =====================================*/
    --SELECT
    --    a.CandidateId,
    --    a.DiscrolExamNo,
    --    a.EqExamNo,
    --    a.ConflictExamNo,
    --    a.IQExamNo,
    --    b.RegistrationNumber,
    --    b.UserName,
    --    c.AppointmentLetterType,
    --    c.OfferdCompanyCode,
    --    c.EmpNo
    --FROM #TempTestResult a
    --LEFT JOIN #TempBasic b
    --    ON a.CandidateId = b.CandidateId
    --LEFT JOIN #TempOfferAppointment c
    --    ON a.CandidateId = c.CandidateId;
		SELECT
		b.CandidateId,
		a.DiscrolExamNo,
		a.EqExamNo,
		a.ConflictExamNo,
		a.IQExamNo,
		b.RegistrationNumber,
		b.UserName,
		c.AppointmentLetterType,
		c.OfferdCompanyCode,
		c.EmpNo
	FROM #TempBasic b
	LEFT JOIN #TempTestResult a
		ON a.CandidateId = b.CandidateId
	LEFT JOIN #TempOfferAppointment c
		ON c.CandidateId = b.CandidateId;



    /*=====================================
      CLEAN UP
    =====================================*/
    DROP TABLE #TempTestResult;
    DROP TABLE #TempBasic;
    DROP TABLE #TempOfferAppointment;

END;
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: Languages, tempPsychometricTestMapping, trecruitcanbasicdtls, trecruitcandidatesignup, trecruitdiscrolansdtls, trecruitdiscrolcandidatedtls, trecruitdiscrolexamdtls, trecruitdiscrolquestype, trecruitdiscrolqusdtls, trecruitotherpost, trecruittraker, trecuitpsycycotesttype */
/****** Object:  StoredProcedure [dbo].[procdishrdtls_Test]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[procdishrdtls_Test] @action             VARCHAR(100)=NULL,           
                                 @phytypeid          INT=NULL,           
                                 @postname           VARCHAR(500)=NULL,           
                                 @deptname           VARCHAR(500)=NULL,           
                                 @candidateattemexam INT=NULL,           
                                 @registrationnumber VARCHAR(200)=NULL,           
                                 @discrolallow       VARCHAR(200)=NULL,           
                                 @Message            VARCHAR(200)=NULL           
AS           
    DECLARE @candidateid INT           
    DECLARE @candiscrolallow VARCHAR(200)           
          
  BEGIN           
        
  if(@phytypeid is null or @phytypeid=0)        
  begin        
  set        
  @phytypeid=null        
  end        
  if(@postname is null or @postname='0')        
  begin        
  set        
  @postname=null        
  end        
  if(@registrationnumber is null or @registrationnumber='0')        
  begin        
  set        
  @registrationnumber=null        
  end        
        
      SELECT @candidateid = candidateid           
      FROM   [dbo].[trecruitcanbasicdtls]           
      WHERE  registrationnumber = @registrationnumber           
          
            
      IF @action = 'Selecttypewisecandidate'  
  BEGIN  
     if(@phytypeid=10)  
     BEGIN  
        --SELECT * FROM [tempPsychometricTestMapping]  
      ;WITH CandidateTest AS  
     (  
      SELECT   
       a.registrationnumber AS referenceno,  
       b.postname,  
       b.deptname AS departmentdivision,  
       a.firstname + ' ' + a.middlename + ' ' + a.lastname AS candidatename,  
       v.SortId,  
       v.RawValue  
      FROM trecruitcanbasicdtls a  
      INNER JOIN trecruitcandidatesignup c ON a.candidateid = c.candidateid  
      INNER JOIN vw_apppost b ON c.username = b.username  
      INNER JOIN tempPsychometricTestMapping d on a.candidateid=d.CandidateID  
      CROSS APPLY (VALUES  
         (10, d.MlqAllow)  
      ) v(SortId, RawValue)  
      WHERE v.RawValue IN ('Completed', 'Reschedule')  
     )  
     SELECT   
      c.referenceno,  
      c.candidatename,  
      t.typename  
     FROM CandidateTest c  
     INNER JOIN trecuitpsycycotesttype t  
      ON c.SortId = t.id  
     WHERE (@phytypeid IS NULL OR t.id = @phytypeid)  
       AND (  
       REPLACE(REPLACE(REPLACE(@postname, ' ', ''), ' ', ''), '  ', '') IS NULL  
       OR REPLACE(REPLACE(REPLACE(c.postname, ' ', ''), ' ', ''), '  ', '') =  
          REPLACE(REPLACE(REPLACE(@postname, ' ', ''), ' ', ''), '  ', '')  
        )  
       AND (@deptname IS NULL OR c.departmentdivision = @deptname)  
       AND (@registrationnumber IS NULL OR c.referenceno = @registrationnumber)  
     ORDER BY c.referenceno DESC;  
          
  
     END  
     ELSE  
      BEGIN  
     ;WITH CandidateTest AS  
   (  
    SELECT   
     a.registrationnumber AS referenceno,  
     b.postname,  
     b.deptname AS departmentdivision,  
     a.firstname + ' ' + a.middlename + ' ' + a.lastname AS candidatename,  
     v.SortId,  
     v.RawValue  
    FROM trecruitcanbasicdtls a  
    INNER JOIN trecruitcandidatesignup c ON a.candidateid = c.candidateid  
    INNER JOIN vw_apppost b ON c.username = b.username  
    CROSS APPLY (VALUES  
       (1, a.discrolallow)  
     , (2, a.conflictallow)  
     , (3, a.iqallow)  
     , (4, a.eqallow)  
     , (5, a.bigfiveallow)  
     , (6, a.firoballow)  
     , (7, a.myersbriggsallow)  
    ) v(SortId, RawValue)  
    WHERE v.RawValue IN ('Completed', 'Reschedule')  
   )  
   SELECT   
    c.referenceno,  
    c.candidatename,  
    t.typename  
   FROM CandidateTest c  
   INNER JOIN trecuitpsycycotesttype t  
    ON c.SortId = t.id  
   WHERE (@phytypeid IS NULL OR t.id = @phytypeid)  
     AND (  
     REPLACE(REPLACE(REPLACE(@postname, ' ', ''), ' ', ''), '  ', '') IS NULL  
     OR REPLACE(REPLACE(REPLACE(c.postname, ' ', ''), ' ', ''), '  ', '') =  
        REPLACE(REPLACE(REPLACE(@postname, ' ', ''), ' ', ''), '  ', '')  
      )  
     AND (@deptname IS NULL OR c.departmentdivision = @deptname)  
     AND (@registrationnumber IS NULL OR c.referenceno = @registrationnumber)  
   ORDER BY c.referenceno DESC;  
  
   END  
      
  END  
  
          
     
          
      IF @action = 'Selecttypewiseotcandidate'           
        BEGIN           
            SELECT [referenceno],           
                   [candidatename],           
                   [typename]           
            FROM   (SELECT             [registrationnumber][referenceno],           
                           a.[firstname]+' '+a.[middlename]+' '+a.[lastname] [candidatename],           
                           CASE           
                             WHEN discrolallow = 'Completed' THEN 1           
                             WHEN discrolallow = 'Reschedule' THEN 1           
        WHEN discrolallow = 'Yes' THEN 10          
                             ELSE discrolallow           
                           END discrolallow,           
                           CASE           
                             WHEN conflictallow = 'Completed' THEN 2           
                             WHEN conflictallow = 'Reschedule' THEN 2           
        WHEN conflictallow = 'Yes' THEN 10          
                             ELSE conflictallow           
                           END conflictallow,           
                           CASE           
                             WHEN iqallow = 'Completed' THEN 3           
                             WHEN iqallow = 'Reschedule' THEN 3           
        WHEN iqallow = 'Yes' THEN 10          
                             ELSE iqallow           
                           END iqallow,           
                           CASE           
                             WHEN eqallow = 'Completed' THEN 4           
                             WHEN eqallow = 'Reschedule' THEN 4           
        WHEN eqallow = 'Yes' THEN 10          
                             ELSE eqallow           
                           END eqallow,          
         CASE           
                             WHEN bigfiveallow = 'Completed' THEN 5           
                             WHEN bigfiveallow = 'Reschedule' THEN 5           
        WHEN bigfiveallow = 'Yes' THEN 10          
                             ELSE bigfiveallow           
                           END bigfiveallow ,          
          CASE           
                             WHEN firoballow = 'Completed' THEN 6           
                             WHEN firoballow = 'Reschedule' THEN 6           
        WHEN firoballow = 'Yes' THEN 10          
                             ELSE firoballow           
                           END firoballow,          
         CASE           
                             WHEN myersbriggsallow = 'Completed' THEN 7           
                             WHEN myersbriggsallow = 'Reschedule' THEN 7           
        WHEN myersbriggsallow = 'Yes' THEN 10          
                             ELSE myersbriggsallow           
                           END myersbriggsallow             
                    FROM   [trecruitcanbasicdtls] a,[trecruitotherpost] b          
                    WHERE   discrolallow IN ( 'Completed', 'Reschedule' )           
                                      
       and a.candidateid=b.candidateid) a,           
                   [dbo].[trecuitpsycycotesttype] b           
            WHERE  a.discrolallow = Cast(b.[id] AS VARCHAR)           
                           
       AND  (@phytypeid is null or b.id = @phytypeid)        
       and (@registrationnumber is null or a.referenceno=@registrationnumber)        
          
       union          
          
       SELECT [referenceno],           
                   [candidatename],           
                   [typename]           
            FROM   (SELECT             [registrationnumber][referenceno],           
                           a.[firstname]+' '+a.[middlename]+' '+a.[lastname] [candidatename],           
                           CASE           
                             WHEN discrolallow = 'Completed' THEN 1           
                             WHEN discrolallow = 'Reschedule' THEN 1           
        WHEN discrolallow = 'Yes' THEN 10          
                             ELSE discrolallow           
                           END discrolallow,           
                           CASE           
                             WHEN conflictallow = 'Completed' THEN 2           
                             WHEN conflictallow = 'Reschedule' THEN 2           
        WHEN conflictallow = 'Yes' THEN 10          
                             ELSE conflictallow           
                           END conflictallow,           
                           CASE           
                             WHEN iqallow = 'Completed' THEN 3           
                             WHEN iqallow = 'Reschedule' THEN 3           
        WHEN iqallow = 'Yes' THEN 10          
                             ELSE iqallow           
                           END iqallow,           
                           CASE           
                             WHEN eqallow = 'Completed' THEN 4           
                             WHEN eqallow = 'Reschedule' THEN 4           
        WHEN eqallow = 'Yes' THEN 10          
                             ELSE eqallow           
                           END eqallow ,          
         CASE           
                             WHEN bigfiveallow = 'Completed' THEN 5           
                             WHEN bigfiveallow = 'Reschedule' THEN 5           
        WHEN bigfiveallow = 'Yes' THEN 10          
                             ELSE bigfiveallow           
                           END bigfiveallow,          
          CASE           
                             WHEN firoballow = 'Completed' THEN 6           
                             WHEN firoballow = 'Reschedule' THEN 6           
        WHEN firoballow = 'Yes' THEN 10          
                             ELSE firoballow           
                           END firoballow,          
         CASE           
                             WHEN myersbriggsallow = 'Completed' THEN 7           
                             WHEN myersbriggsallow = 'Reschedule' THEN 7           
        WHEN myersbriggsallow = 'Yes' THEN 10          
                             ELSE myersbriggsallow           
                           END myersbriggsallow             
                    FROM  [trecruitcanbasicdtls] a,[trecruitotherpost] b          
                    WHERE    conflictallow IN ( 'Completed', 'Reschedule' )           
                                     
       and a.candidateid=b.candidateid) a,           
                   [dbo].[trecuitpsycycotesttype] b           
            WHERE  a.conflictallow = Cast(b.[id] AS VARCHAR)           
                   AND  (@phytypeid is null or b.id = @phytypeid)        
       and (@registrationnumber is null or a.referenceno=@registrationnumber)        
          
       union          
          
       SELECT [referenceno],           
                   [candidatename],           
                   [typename]           
            FROM   (SELECT  [registrationnumber][referenceno],           
                           a.[firstname]+' '+a.[middlename]+' '+a.[lastname] [candidatename],           
                           CASE           
                             WHEN discrolallow = 'Completed' THEN 1           
                             WHEN discrolallow = 'Reschedule' THEN 1           
        WHEN discrolallow = 'Yes' THEN 10          
                             ELSE discrolallow           
                           END discrolallow,           
                           CASE           
                             WHEN conflictallow = 'Completed' THEN 2           
                             WHEN conflictallow = 'Reschedule' THEN 2           
        WHEN conflictallow = 'Yes' THEN 10         
                             ELSE conflictallow           
                           END conflictallow,           
                           CASE           
                             WHEN iqallow = 'Completed' THEN 3           
                             WHEN iqallow = 'Reschedule' THEN 3           
        WHEN iqallow = 'Yes' THEN 10          
                             ELSE iqallow           
                           END iqallow,           
                           CASE           
                             WHEN eqallow = 'Completed' THEN 4           
                             WHEN eqallow = 'Reschedule' THEN 4           
        WHEN eqallow = 'Yes' THEN 10          
                             ELSE eqallow           
                           END eqallow ,          
         CASE           
                             WHEN bigfiveallow = 'Completed' THEN 5           
                             WHEN bigfiveallow = 'Reschedule' THEN 5           
        WHEN bigfiveallow = 'Yes' THEN 10          
                             ELSE bigfiveallow           
            END bigfiveallow ,          
          CASE           
                             WHEN firoballow = 'Completed' THEN 6           
                             WHEN firoballow = 'Reschedule' THEN 6           
        WHEN firoballow = 'Yes' THEN 10          
                             ELSE firoballow           
                            END firoballow ,          
       CASE           
                             WHEN myersbriggsallow = 'Completed' THEN 7           
                             WHEN myersbriggsallow = 'Reschedule' THEN 7           
        WHEN myersbriggsallow = 'Yes' THEN 10          
                             ELSE myersbriggsallow           
                           END myersbriggsallow           
                    FROM   [trecruitcanbasicdtls] a,[trecruitotherpost] b          
                    WHERE    eqallow IN ( 'Completed', 'Reschedule' )           
                                     
       and a.candidateid=b.candidateid) a,           
                   [dbo].[trecuitpsycycotesttype] b           
            WHERE  a.eqallow = Cast(b.[id] AS VARCHAR)           
                   AND  (@phytypeid is null or b.id = @phytypeid)        
       and (@registrationnumber is null or a.referenceno=@registrationnumber)        
          
       union          
          
       SELECT [referenceno],           
                   [candidatename],           
                   [typename]           
            FROM   (SELECT  [registrationnumber][referenceno],           
                           a.[firstname]+' '+a.[middlename]+' '+a.[lastname] [candidatename],           
                           CASE           
                             WHEN discrolallow = 'Completed' THEN 1           
                             WHEN discrolallow = 'Reschedule' THEN 1           
        WHEN discrolallow = 'Yes' THEN 10          
                             ELSE discrolallow           
                           END discrolallow,           
                           CASE           
                             WHEN conflictallow = 'Completed' THEN 2           
                             WHEN conflictallow = 'Reschedule' THEN 2           
        WHEN conflictallow = 'Yes' THEN 10          
                             ELSE conflictallow           
                           END conflictallow,           
                           CASE           
                             WHEN iqallow = 'Completed' THEN 3           
                             WHEN iqallow = 'Reschedule' THEN 3           
        WHEN iqallow = 'Yes' THEN 10          
                             ELSE iqallow           
                           END iqallow,           
                           CASE           
               WHEN eqallow = 'Completed' THEN 4           
                             WHEN eqallow = 'Reschedule' THEN 4           
        WHEN eqallow = 'Yes' THEN 10          
                    ELSE eqallow           
                           END eqallow ,          
         CASE           
                             WHEN bigfiveallow = 'Completed' THEN 5           
                             WHEN bigfiveallow = 'Reschedule' THEN 5           
        WHEN bigfiveallow = 'Yes' THEN 10          
                             ELSE bigfiveallow           
                           END bigfiveallow ,          
          CASE           
                             WHEN firoballow = 'Completed' THEN 6           
                             WHEN firoballow = 'Reschedule' THEN 6           
        WHEN firoballow = 'Yes' THEN 10          
                             ELSE firoballow           
                           END firoballow,          
         CASE           
                             WHEN myersbriggsallow = 'Completed' THEN 7           
                             WHEN myersbriggsallow = 'Reschedule' THEN 7           
        WHEN myersbriggsallow = 'Yes' THEN 10          
                             ELSE myersbriggsallow           
                           END myersbriggsallow            
                    FROM   [trecruitcanbasicdtls] a,[trecruitotherpost] b          
         WHERE    iqallow IN ( 'Completed', 'Reschedule' )           
                                     
       and a.candidateid=b.candidateid) a,           
                   [dbo].[trecuitpsycycotesttype] b           
            WHERE  a.iqallow = Cast(b.[id] AS VARCHAR)           
                    AND  (@phytypeid is null or b.id = @phytypeid)        
       and (@registrationnumber is null or a.referenceno=@registrationnumber)        
   union          
          
       SELECT [referenceno],           
                   [candidatename],           
                   [typename]           
            FROM   (SELECT  [registrationnumber][referenceno],           
                           a.[firstname]+' '+a.[middlename]+' '+a.[lastname] [candidatename],           
                           CASE           
                             WHEN discrolallow = 'Completed' THEN 1           
                             WHEN discrolallow = 'Reschedule' THEN 1           
        WHEN discrolallow = 'Yes' THEN 10          
                             ELSE discrolallow           
                           END discrolallow,           
                           CASE           
                             WHEN conflictallow = 'Completed' THEN 2           
                             WHEN conflictallow = 'Reschedule' THEN 2           
        WHEN conflictallow = 'Yes' THEN 10          
                             ELSE conflictallow           
                           END conflictallow,           
                           CASE           
                             WHEN iqallow = 'Completed' THEN 3           
                             WHEN iqallow = 'Reschedule' THEN 3           
        WHEN iqallow = 'Yes' THEN 10          
                             ELSE iqallow           
                           END iqallow,           
                           CASE           
                             WHEN eqallow = 'Completed' THEN 4           
                             WHEN eqallow = 'Reschedule' THEN 4           
        WHEN eqallow = 'Yes' THEN 10          
                             ELSE eqallow           
                           END eqallow ,          
         CASE           
                             WHEN bigfiveallow = 'Completed' THEN 5           
                             WHEN bigfiveallow = 'Reschedule' THEN 5           
        WHEN bigfiveallow = 'Yes' THEN 10          
                             ELSE bigfiveallow           
                           END bigfiveallow ,          
          CASE           
                             WHEN firoballow = 'Completed' THEN 6           
                             WHEN firoballow = 'Reschedule' THEN 6           
        WHEN firoballow = 'Yes' THEN 10          
                             ELSE firoballow           
                           END firoballow,          
         CASE           
                             WHEN myersbriggsallow = 'Completed' THEN 7           
                             WHEN myersbriggsallow = 'Reschedule' THEN 7           
        WHEN myersbriggsallow = 'Yes' THEN 10          
                             ELSE myersbriggsallow           
                           END myersbriggsallow            
                    FROM   [trecruitcanbasicdtls] a,[trecruitotherpost] b          
                    WHERE  bigfiveallow IN ( 'Completed', 'Reschedule' )           
                                     
       and a.candidateid=b.candidateid) a,           
                   [dbo].[trecuitpsycycotesttype] b           
            WHERE  a.bigfiveallow = Cast(b.[id] AS VARCHAR)           
                    AND  (@phytypeid is null or b.id = @phytypeid)        
       and (@registrationnumber is null or a.referenceno=@registrationnumber)        
        union          
          
       SELECT [referenceno],           
                   [candidatename],           
                   [typename]           
            FROM   (SELECT  [registrationnumber][referenceno],           
                           a.[firstname]+' '+a.[middlename]+' '+a.[lastname] [candidatename],           
                           CASE           
                             WHEN discrolallow = 'Completed' THEN 1           
                    WHEN discrolallow = 'Reschedule' THEN 1           
        WHEN discrolallow = 'Yes' THEN 10          
                             ELSE discrolallow           
                           END discrolallow,           
                           CASE           
                             WHEN conflictallow = 'Completed' THEN 2           
                             WHEN conflictallow = 'Reschedule' THEN 2           
        WHEN conflictallow = 'Yes' THEN 10          
                             ELSE conflictallow           
                           END conflictallow,           
                           CASE           
                             WHEN iqallow = 'Completed' THEN 3           
                             WHEN iqallow = 'Reschedule' THEN 3           
        WHEN iqallow = 'Yes' THEN 10          
                             ELSE iqallow           
                           END iqallow,           
                           CASE           
                             WHEN eqallow = 'Completed' THEN 4           
                             WHEN eqallow = 'Reschedule' THEN 4           
        WHEN eqallow = 'Yes' THEN 10          
                             ELSE eqallow           
                           END eqallow ,          
         CASE           
                             WHEN bigfiveallow = 'Completed' THEN 5           
                             WHEN bigfiveallow = 'Reschedule' THEN 5           
        WHEN bigfiveallow = 'Yes' THEN 10          
                             ELSE bigfiveallow           
                           END bigfiveallow ,          
          CASE           
                             WHEN firoballow = 'Completed' THEN 6           
                             WHEN firoballow = 'Reschedule' THEN 6           
        WHEN firoballow = 'Yes' THEN 10          
                             ELSE firoballow           
                           END firoballow,          
         CASE           
                             WHEN myersbriggsallow = 'Completed' THEN 7           
                             WHEN myersbriggsallow = 'Reschedule' THEN 7           
        WHEN myersbriggsallow = 'Yes' THEN 10          
                             ELSE myersbriggsallow           
                           END myersbriggsallow            
                    FROM   [trecruitcanbasicdtls] a,[trecruitotherpost] b          
                    WHERE    firoballow IN ( 'Completed', 'Reschedule' )           
                                     
       and a.candidateid=b.candidateid) a,           
                   [dbo].[trecuitpsycycotesttype] b           
            WHERE  a.firoballow = Cast(b.[id] AS VARCHAR)           
                    AND  (@phytypeid is null or b.id = @phytypeid)        
       and (@registrationnumber is null or a.referenceno=@registrationnumber)        
           union          
          
       SELECT [referenceno],           
                   [candidatename],           
                   [typename]           
            FROM   (SELECT  [registrationnumber][referenceno],           
                           a.[firstname]+' '+a.[middlename]+' '+a.[lastname] [candidatename],           
                           CASE           
                             WHEN discrolallow = 'Completed' THEN 1           
                             WHEN discrolallow = 'Reschedule' THEN 1           
        WHEN discrolallow = 'Yes' THEN 10          
                             ELSE discrolallow           
                           END discrolallow,           
                           CASE           
                             WHEN conflictallow = 'Completed' THEN 2           
                             WHEN conflictallow = 'Reschedule' THEN 2           
        WHEN conflictallow = 'Yes' THEN 10          
                             ELSE conflictallow           
                           END conflictallow,           
                           CASE           
                            WHEN iqallow = 'Completed' THEN 3           
         WHEN iqallow = 'Reschedule' THEN 3           
        WHEN iqallow = 'Yes' THEN 10          
                             ELSE iqallow           
                           END iqallow,           
                           CASE           
                             WHEN eqallow = 'Completed' THEN 4           
                             WHEN eqallow = 'Reschedule' THEN 4           
     WHEN eqallow = 'Yes' THEN 10          
                             ELSE eqallow           
                           END eqallow ,          
         CASE           
                             WHEN bigfiveallow = 'Completed' THEN 5           
                             WHEN bigfiveallow = 'Reschedule' THEN 5           
        WHEN bigfiveallow = 'Yes' THEN 10          
                             ELSE bigfiveallow           
                           END bigfiveallow ,          
          CASE           
                             WHEN firoballow = 'Completed' THEN 6           
                             WHEN firoballow = 'Reschedule' THEN 6           
        WHEN firoballow = 'Yes' THEN 10          
                             ELSE firoballow           
                           END firoballow,          
         CASE           
                             WHEN myersbriggsallow = 'Completed' THEN 7           
                             WHEN myersbriggsallow = 'Reschedule' THEN 7           
        WHEN myersbriggsallow = 'Yes' THEN 10          
                             ELSE myersbriggsallow           
                           END myersbriggsallow            
                    FROM   [trecruitcanbasicdtls] a,[trecruitotherpost] b          
                    WHERE    myersbriggsallow IN ( 'Completed', 'Reschedule' )           
                                     
       and a.candidateid=b.candidateid) a,           
                   [dbo].[trecuitpsycycotesttype] b           
            WHERE  a.myersbriggsallow = Cast(b.[id] AS VARCHAR)           
                    AND  (@phytypeid is null or b.id = @phytypeid)        
       and (@registrationnumber is null or a.referenceno=@registrationnumber)        
        
       order by referenceno desc        
        END           
          
      IF @action = 'Selectquesans'           
        BEGIN           
            SELECT [disquestype],           
                   [quesserialno],           
                   [question],           
                   f.[answer]           
            FROM   [trecruitdiscrolcandidatedtls] a,           
                  [dbo].[trecruitdiscrolqusdtls] b,           
                   [dbo].[trecruitdiscrolquestype] c,           
                   [dbo].[trecruitdiscrolansdtls]f,           
                   [dbo].[trecruitcanbasicdtls] d,           
                   [dbo].[languages]e           
            WHERE  a.[languageid] = b.[languageid]           
                   AND a.[questionid] = b.[quesserialno]           
                   AND b.[disquestypeid] = c.[id]           
                   AND a.[candidateid] = d.[candidateid]           
                   AND a.[languageid] = e.[id]           
                   AND a.answer = f.number           
                   AND a.[languageid] = f.[languageid]           
                   AND a.candidateid = @candidateid           
                   AND [candidateattemexam] = @candidateattemexam           
            ORDER  BY [quesserialno]           
        END           
          
      IF @action = 'Reschedule'           
        BEGIN           
            --SELECT @candiscrolallow = [discrolallow]           
            --FROM   [Recruitment].[dbo].[trecruittraker]           
            --WHERE  [candidateid] = @candidateid           
            --GROUP  BY [discrolallow],           
            --          [conflictallow],           
            --          [iqallow],           
            --          [eqallow]           
          
   SELECT @candiscrolallow = [discrolallow]           
            FROM   [dbo].[trecruitcanbasicdtls]          
            WHERE  [candidateid] = @candidateid           
            GROUP  BY [discrolallow],           
    [conflictallow],           
                      [iqallow],           
                      [eqallow]           
          
                       
            IF @candiscrolallow = 'Completed'           
              BEGIN           
                  UPDATE [trecruitcanbasicdtls]           
                  SET    [discrolallow] = 'Reschedule'           
                  WHERE  [candidateid] = @candidateid           
              END           
            ELSE           
              BEGIN           
                  SET @message=1           
              END           
        END           
          
      IF @action = 'SELECTEXAMNO'           
    BEGIN           
            SELECT [attemexam],           
                   CASE           
                     WHEN [attemexam] = 1 THEN Cast('1st Exam' AS VARCHAR)           
                     WHEN [attemexam] = 2 THEN Cast('2nd Exam'AS VARCHAR)           
                     WHEN [attemexam] = 3 THEN Cast('3rd Exam'AS VARCHAR)           
                     ELSE Cast([attemexam]AS VARCHAR) + '' + 'th Exam'           
                   END [attemexamtext]           
            FROM   [trecruitdiscrolexamdtls]           
            WHERE  candidateid = @candidateid           
                   AND finalsubmit = 'Yes'           
            ORDER  BY [attemexam]           
        END           
          
      IF @action = 'Selecttypewisetotalno'           
        BEGIN           
            SELECT c.[disquestype],           
                   a.questionid,           
                   a.answer,           
                   totscore           
            FROM   [trecruitdiscrolcandidatedtls] a,           
                   [dbo].[trecruitdiscrolqusdtls] b,           
                   [dbo].[trecruitdiscrolquestype] c,           
                   [dbo].[trecruitdiscrolansdtls]f,           
                   [dbo].[trecruitcanbasicdtls] d,           
                   [dbo].[languages]e,           
                   (SELECT c.[disquestype],           
                           Sum (a.answer)totscore           
                    FROM   [trecruitdiscrolcandidatedtls] a,           
                           [dbo].[trecruitdiscrolqusdtls] b,           
                           [dbo].[trecruitdiscrolquestype] c,           
                           [dbo].[trecruitdiscrolansdtls]f,           
                       [dbo].[trecruitcanbasicdtls] d,           
                           [dbo].[languages]e           
                    WHERE  a.[languageid] = b.[languageid]           
                           AND a.[questionid] = b.[quesserialno]           
                           AND b.[disquestypeid] = c.[id]           
                           AND a.[candidateid] = d.[candidateid]           
                           AND a.[languageid] = e.[id]           
                            AND a.answer = f.[number]          
         and a.[languageid]=f.[languageid]             
                           AND a.candidateid = @candidateid           
                           AND [candidateattemexam] = @candidateattemexam           
                    GROUP  BY c.[disquestype]) z           
            WHERE  a.[languageid] = b.[languageid]           
                   AND a.[questionid] = b.[quesserialno]           
                   AND b.[disquestypeid] = c.[id]           
                   AND a.[candidateid] = d.[candidateid]           
                   AND a.[languageid] = e.[id]           
                    AND a.answer = f.[number]          
     and a.[languageid]=f.[languageid]             
                   AND a.candidateid = @candidateid           
                   AND [candidateattemexam] = @candidateattemexam           
                   AND c.[disquestype] = z.[disquestype]           
            ORDER  BY [disquestype]           
        END           
          
      IF @action = 'Discrolgraph'           
        BEGIN           
            SELECT ( d.totscore * 1.363636 ) TIGERfinalscore,           
                   ( a.totscore * 2 )        CHAMELEONfinalscore,           
                   ( e.totscore * 2.1428 )   TURTLEfinalscore,           
                   ( b.totscore * 1.363636 ) EAGLEfinalscore,           
                   ( a.totscore * 2 )        SALMONfinalscore           
            FROM   (SELECT c.[disquestype],           
                           a.candidateid,           
                           Sum (a.answer)totscore           
                    FROM  [trecruitdiscrolcandidatedtls] a,           
                           [dbo].[trecruitdiscrolqusdtls] b,           
                           [dbo].[trecruitdiscrolquestype] c,           
                           [dbo].[trecruitdiscrolansdtls]f,           
                           [dbo].[trecruitcanbasicdtls] d,           
                           [dbo].[languages]e           
                    WHERE  a.[languageid] = b.[languageid]           
                           AND a.[questionid] = b.[quesserialno]           
                           AND b.[disquestypeid] = c.[id]           
                           AND a.[candidateid] = d.[candidateid]           
                           AND a.[languageid] = e.[id]           
                            AND a.answer = f.[number]          
         and a.[languageid]=f.[languageid]              
                           AND a.candidateid = @candidateid           
                           AND [candidateattemexam] = @candidateattemexam           
                           AND c.[disquestype] = 'CHAMELEON'           
                    GROUP  BY c.[disquestype],           
                              a.candidateid) a,           
                   (SELECT c.[disquestype],           
                           a.candidateid,           
                           Sum (a.answer)totscore           
                    FROM   [trecruitdiscrolcandidatedtls] a,           
                           [dbo].[trecruitdiscrolqusdtls] b,           
                           [dbo].[trecruitdiscrolquestype] c,           
                           [dbo].[trecruitdiscrolansdtls]f,           
                           [dbo].[trecruitcanbasicdtls] d,           
                           [dbo].[languages]e           
                    WHERE  a.[languageid] = b.[languageid]           
                           AND a.[questionid] = b.[quesserialno]           
                           AND b.[disquestypeid] = c.[id]           
                           AND a.[candidateid] = d.[candidateid]           
                           AND a.[languageid] = e.[id]           
                            AND a.answer = f.[number]          
         and a.[languageid]=f.[languageid]             
                           AND a.candidateid = @candidateid           
                           AND [candidateattemexam] = @candidateattemexam           
                           AND c.[disquestype] = 'EAGLE'           
                    GROUP  BY c.[disquestype],           
                              a.candidateid) b,           
                   (SELECT c.[disquestype],           
                           a.candidateid,           
                           Sum (a.answer)totscore           
                    FROM   [trecruitdiscrolcandidatedtls] a,           
                           [dbo].[trecruitdiscrolqusdtls] b,           
                           [dbo].[trecruitdiscrolquestype] c,           
                           [dbo].[trecruitdiscrolansdtls]f,           
                           [dbo].[trecruitcanbasicdtls] d,           
                           [dbo].[languages]e           
                    WHERE  a.[languageid] = b.[languageid]           
                           AND a.[questionid] = b.[quesserialno]           
                           AND b.[disquestypeid] = c.[id]           
                           AND a.[candidateid] = d.[candidateid]           
                           AND a.[languageid] = e.[id]           
                            AND a.answer = f.[number]          
         and a.[languageid]=f.[languageid]             
                           AND a.candidateid = @candidateid           
                           AND [candidateattemexam] = @candidateattemexam           
                          AND c.[disquestype] = 'SALMON'           
                    GROUP  BY c.[disquestype],           
                              a.candidateid) c,           
                   (SELECT c.[disquestype],           
                           a.candidateid,           
                           Sum (a.answer)totscore           
                    FROM   [trecruitdiscrolcandidatedtls] a,           
                           [dbo].[trecruitdiscrolqusdtls] b,           
                           [dbo].[trecruitdiscrolquestype] c,           
                           [dbo].[trecruitdiscrolansdtls]f,           
                           [dbo].[trecruitcanbasicdtls] d,           
                           [dbo].[languages]e           
                    WHERE  a.[languageid] = b.[languageid]           
                           AND a.[questionid] = b.[quesserialno]           
                           AND b.[disquestypeid] = c.[id]           
                           AND a.[candidateid] = d.[candidateid]           
                           AND a.[languageid] = e.[id]           
                            AND a.answer = f.[number]          
         and a.[languageid]=f.[languageid]             
                           AND a.candidateid = @candidateid           
                           AND [candidateattemexam] = @candidateattemexam           
                           AND c.[disquestype] = 'TIGER'           
                    GROUP  BY c.[disquestype],           
                              a.candidateid) d,           
                   (SELECT c.[disquestype],           
                           a.candidateid,           
                           Sum (a.answer)totscore           
                    FROM   [trecruitdiscrolcandidatedtls] a,           
                           [dbo].[trecruitdiscrolqusdtls] b,           
                           [dbo].[trecruitdiscrolquestype] c,           
                           [dbo].[trecruitdiscrolansdtls]f,           
                           [dbo].[trecruitcanbasicdtls] d,           
            [dbo].[languages]e           
                    WHERE  a.[languageid] = b.[languageid]           
                           AND a.[questionid] = b.[quesserialno]           
                           AND b.[disquestypeid] = c.[id]           
                           AND a.[candidateid] = d.[candidateid]           
                           AND a.[languageid] = e.[id]           
                            AND a.answer = f.[number]          
         and a.[languageid]=f.[languageid]             
                           AND a.candidateid = @candidateid           
                           AND [candidateattemexam] = @candidateattemexam           
                           AND c.[disquestype] = 'TURTLE'           
                    GROUP  BY c.[disquestype],           
                              a.candidateid) e           
            WHERE  a.candidateid = b.candidateid           
                   AND a.candidateid = c.candidateid           
                   AND a.candidateid = d.candidateid           
                   AND a.candidateid = e.candidateid           
        END           
          
      IF @action = 'Activeinactiveresbutton'           
        BEGIN           
            SELECT           
                   a.[discrolallow]           
            FROM   [dbo].[trecruitcanbasicdtls] a                          
            WHERE a.candidateid = @candidateid           
        END           
  END   
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: Languages, tdiscrolscoremappingChameleon, tdiscrolscoremappingEagle, tdiscrolscoremappingSalmon, tdiscrolscoremappingTiger, tdiscrolscoremappingTurtle, trecruitcanbasicdtls, trecruitdiscrolansdtls, trecruitdiscrolcandidatedtls, trecruitdiscrolquestype, trecruitdiscrolqusdtls */
/****** Object:  StoredProcedure [dbo].[procdisreport_demo]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 --  procdisreport  1, 'Candidate004131'

CREATE PROC [dbo].[procdisreport_demo] @candidateattemexam INT=NULL,   
                                 @registrationnumber VARCHAR(200)=NULL   
AS   
    DECLARE @candidateid INT   
    DECLARE @exquesset INT   
  
  BEGIN   
      SELECT @candidateid = candidateid   
      FROM   [dbo].[trecruitcanbasicdtls]   
      WHERE  registrationnumber = @registrationnumber   
  
      --SELECT @exquesset = exquesset   
      --FROM   (SELECT DISTINCT ( [exquesset] ) exquesset   
      --        FROM   trecruitdiscrolcandidatedtls   
      --        WHERE  [candidateattemexam] = @candidateattemexam   
      --               AND candidateid = @candidateid)a   
  
      SELECT [disquestype],   
             totscore score ,  
    CASE [disquestype]   
                  WHEN 'TIGER' THEN (Select  [scoreinmap] from [dbo].[tdiscrolscoremappingTiger] where [score]=totscore)  
                  WHEN 'CHAMELEON' THEN (Select  [scoreinmap] from [dbo].[tdiscrolscoremappingChameleon] where [score]=totscore)  
                  WHEN 'TURTLE' THEN (Select  [scoreinmap] from [dbo].[tdiscrolscoremappingTurtle] where [score]=totscore)  
                  WHEN 'EAGLE' THEN (Select  [scoreinmap] from [dbo].[tdiscrolscoremappingEagle] where [score]=totscore)  
                  WHEN 'SALMON' THEN (Select  [scoreinmap] from [dbo].[tdiscrolscoremappingSalmon] where [score]=totscore)  
                  ELSE [disquestype]   
                END totscore , discrolallow  
      FROM   (SELECT c.[disquestype],   
                     (Sum (a.answer))totscore , d.discrolallow  
              FROM   [dbo].[trecruitdiscrolcandidatedtls] a,   
                     [dbo].[trecruitdiscrolqusdtls] b,   
                     [dbo].[trecruitdiscrolquestype] c,   
                     [dbo].[trecruitdiscrolansdtls]f,   
                     [dbo].[trecruitcanbasicdtls] d,   
                     [dbo].[languages]e   
              WHERE  a.[languageid] = b.[languageid]   
                     AND a.[questionid] = b.[quesserialno]   
                     AND b.[disquestypeid] = c.[id]   
                     AND a.[candidateid] = d.[candidateid]   
                     AND a.[languageid] = e.[id]   
                     AND a.answer = f.[number]   
                     AND a.[languageid] = f.[languageid]   
                     AND a.candidateid = @candidateid   
                     AND [candidateattemexam] = @candidateattemexam   
                     AND c.[disquestype] = 'TIGER'   
                    -- AND b.[queslanset] = @exquesset   
              GROUP  BY c.[disquestype],   
                        a.candidateid ,
						d.discrolallow
              UNION   
              SELECT c.[disquestype],   
                     ( Sum (a.answer))totscore ,d.discrolallow    
              FROM   [dbo].[trecruitdiscrolcandidatedtls] a,   
                     [dbo].[trecruitdiscrolqusdtls] b,   
                     [dbo].[trecruitdiscrolquestype] c,   
                     [dbo].[trecruitdiscrolansdtls]f,   
                     [dbo].[trecruitcanbasicdtls] d,   
                     [dbo].[languages]e   
              WHERE  a.[languageid] = b.[languageid]   
                     AND a.[questionid] = b.[quesserialno]   
                     AND b.[disquestypeid] = c.[id]   
                     AND a.[candidateid] = d.[candidateid]   
                     AND a.[languageid] = e.[id]   
                     AND a.answer = f.[number]   
                     AND a.[languageid] = f.[languageid]   
                     AND a.candidateid = @candidateid   
                     AND [candidateattemexam] = @candidateattemexam   
                     AND c.[disquestype] = 'CHAMELEON'   
                    -- AND b.[queslanset] = @exquesset   
              GROUP  BY c.[disquestype],   
                        a.candidateid ,
						d.discrolallow
              UNION   
              SELECT c.[disquestype],   
                     ( Sum (a.answer))totscore ,d.discrolallow    
              FROM   [dbo].[trecruitdiscrolcandidatedtls] a,   
                     [dbo].[trecruitdiscrolqusdtls] b,   
                     [dbo].[trecruitdiscrolquestype] c,   
              [dbo].[trecruitdiscrolansdtls]f,   
                     [dbo].[trecruitcanbasicdtls] d,   
                     [dbo].[languages]e   
              WHERE  a.[languageid] = b.[languageid]   
                     AND a.[questionid] = b.[quesserialno]   
                     AND b.[disquestypeid] = c.[id]   
                     AND a.[candidateid] = d.[candidateid]   
                     AND a.[languageid] = e.[id]   
                     AND a.answer = f.[number]   
                     AND a.[languageid] = f.[languageid]   
                     AND a.candidateid = @candidateid   
                     AND [candidateattemexam] = @candidateattemexam   
                     AND c.[disquestype] = 'TURTLE'   
                    -- AND b.[queslanset] = @exquesset   
              GROUP  BY c.[disquestype],   
                        a.candidateid ,
						d.discrolallow
              UNION   
              SELECT c.[disquestype],   
                     ( Sum (a.answer))totscore ,d.discrolallow    
              FROM   [dbo].[trecruitdiscrolcandidatedtls] a,   
                     [dbo].[trecruitdiscrolqusdtls] b,   
                     [dbo].[trecruitdiscrolquestype] c,   
                     [dbo].[trecruitdiscrolansdtls]f,   
                     [dbo].[trecruitcanbasicdtls] d,   
                     [dbo].[languages]e   
              WHERE  a.[languageid] = b.[languageid]   
                     AND a.[questionid] = b.[quesserialno]   
                     AND b.[disquestypeid] = c.[id]   
                     AND a.[candidateid] = d.[candidateid]   
                     AND a.[languageid] = e.[id]   
                     AND a.answer = f.[number]   
                     AND a.[languageid] = f.[languageid]   
                     AND a.candidateid = @candidateid   
                     AND [candidateattemexam] = @candidateattemexam   
                     AND c.[disquestype] = 'EAGLE'   
                    -- AND b.[queslanset] = @exquesset   
              GROUP  BY c.[disquestype],   
                        a.candidateid ,
						d.discrolallow
              UNION   
              SELECT c.[disquestype],   
                     ( Sum (a.answer))totscore ,d.discrolallow    
              FROM   [dbo].[trecruitdiscrolcandidatedtls] a,   
                     [dbo].[trecruitdiscrolqusdtls] b,   
                     [dbo].[trecruitdiscrolquestype] c,   
                     [dbo].[trecruitdiscrolansdtls]f,   
                     [dbo].[trecruitcanbasicdtls] d,   
                     [dbo].[languages]e   
              WHERE  a.[languageid] = b.[languageid]   
                     AND a.[questionid] = b.[quesserialno]   
                     AND b.[disquestypeid] = c.[id]   
                     AND a.[candidateid] = d.[candidateid]   
                     AND a.[languageid] = e.[id]   
                     AND a.answer = f.[number]   
                     AND a.[languageid] = f.[languageid]   
                     AND a.candidateid = @candidateid   
                     AND [candidateattemexam] = @candidateattemexam   
                     AND c.[disquestype] = 'SALMON'   
                    -- AND b.[queslanset] = @exquesset   
              GROUP  BY c.[disquestype],   
                        a.candidateid ,d.discrolallow)a   
      ORDER  BY CASE [disquestype]   
                  WHEN 'TIGER' THEN '0'   
                  WHEN 'CHAMELEON' THEN '1'   
                  WHEN 'TURTLE' THEN '2'   
                  WHEN 'EAGLE' THEN '3'   
                  WHEN 'SALMON' THEN '4'   
                  ELSE [disquestype]   
                END   
  END 
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: Languages, trecruitcanbasicdtls, trecruitdiscrolansdtls, trecruitdiscrolcandidatedtls, trecruitdiscrolquestype, trecruitdiscrolqusdtls */
/****** Object:  StoredProcedure [dbo].[procdisreportdemo]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[procdisreportdemo]
@candidateattemexam INT=NULL, 
@registrationnumber VARCHAR(200)=NULL 
as
DECLARE @candidateid INT 

begin
SELECT @candidateid = candidateid 
      FROM   [dbo].[trecruitcanbasicdtls] 
      WHERE  registrationnumber = @registrationnumber 

	   
					select 
					[disquestype],	totscore from	  
					
					
					(SELECT c.[disquestype], 
                          
                           (Sum (a.answer)* 1.363636 )totscore 
                    FROM   [dbo].[trecruitdiscrolcandidatedtls] a, 
                           [dbo].[trecruitdiscrolqusdtls] b, 
                           [dbo].[trecruitdiscrolquestype] c, 
                           [dbo].[trecruitdiscrolansdtls]f, 
                           [dbo].[trecruitcanbasicdtls] d, 
                           [dbo].[languages]e 
                    WHERE  a.[languageid] = b.[languageid] 
                           AND a.[questionid] = b.[quesserialno] 
                           AND b.[disquestypeid] = c.[id] 
                           AND a.[candidateid] = d.[candidateid] 
                           AND a.[languageid] = e.[id] 
                            AND a.answer = f.[number]
						   and a.[languageid]=f.[languageid]   
                           AND a.candidateid = @candidateid
                           AND [candidateattemexam] = @candidateattemexam
                           AND c.[disquestype] = 'TIGER' 
                    GROUP  BY c.[disquestype], 
                              a.candidateid
							  union

            SELECT c.[disquestype], 
                           
                           (Sum (a.answer)* 2 )totscore 
                    FROM   [dbo].[trecruitdiscrolcandidatedtls] a, 
                           [dbo].[trecruitdiscrolqusdtls] b, 
                           [dbo].[trecruitdiscrolquestype] c, 
                           [dbo].[trecruitdiscrolansdtls]f, 
                           [dbo].[trecruitcanbasicdtls] d, 
                           [dbo].[languages]e 
                    WHERE  a.[languageid] = b.[languageid] 
                           AND a.[questionid] = b.[quesserialno] 
                           AND b.[disquestypeid] = c.[id] 
                           AND a.[candidateid] = d.[candidateid] 
                           AND a.[languageid] = e.[id] 
                            AND a.answer = f.[number]
						   and a.[languageid]=f.[languageid]    
                           AND a.candidateid = @candidateid
                           AND [candidateattemexam] = @candidateattemexam
                           AND c.[disquestype] = 'CHAMELEON' 
                    GROUP  BY c.[disquestype], 
                              a.candidateid
							  union
							  SELECT c.[disquestype], 
                          
                           (Sum (a.answer)* 2.1428 )totscore 
                    FROM   [dbo].[trecruitdiscrolcandidatedtls] a, 
                           [dbo].[trecruitdiscrolqusdtls] b, 
                           [dbo].[trecruitdiscrolquestype] c, 
                           [dbo].[trecruitdiscrolansdtls]f, 
                           [dbo].[trecruitcanbasicdtls] d, 
                           [dbo].[languages]e 
                    WHERE  a.[languageid] = b.[languageid] 
                           AND a.[questionid] = b.[quesserialno] 
                           AND b.[disquestypeid] = c.[id] 
                           AND a.[candidateid] = d.[candidateid] 
                           AND a.[languageid] = e.[id] 
                            AND a.answer = f.[number]
						   and a.[languageid]=f.[languageid]   
                           AND a.candidateid = @candidateid
                           AND [candidateattemexam] = @candidateattemexam
                           AND c.[disquestype] = 'TURTLE' 
                    GROUP  BY c.[disquestype], 
                              a.candidateid
  union
							  SELECT c.[disquestype], 
                           
                           (Sum (a.answer)* 1.363636)totscore 
                    FROM   [dbo].[trecruitdiscrolcandidatedtls] a, 
                           [dbo].[trecruitdiscrolqusdtls] b, 
                           [dbo].[trecruitdiscrolquestype] c, 
                           [dbo].[trecruitdiscrolansdtls]f, 
                           [dbo].[trecruitcanbasicdtls] d, 
                           [dbo].[languages]e 
                    WHERE  a.[languageid] = b.[languageid] 
                           AND a.[questionid] = b.[quesserialno] 
                           AND b.[disquestypeid] = c.[id] 
                           AND a.[candidateid] = d.[candidateid] 
                           AND a.[languageid] = e.[id] 
                            AND a.answer = f.[number]
						   and a.[languageid]=f.[languageid]    
                           AND a.candidateid = @candidateid
                           AND [candidateattemexam] = @candidateattemexam
                           AND c.[disquestype] = 'EAGLE' 
                    GROUP  BY c.[disquestype], 
                              a.candidateid

							   union
							  SELECT c.[disquestype], 
                           
                           (Sum (a.answer)*2)totscore 
                    FROM   [dbo].[trecruitdiscrolcandidatedtls] a, 
                           [dbo].[trecruitdiscrolqusdtls] b, 
                           [dbo].[trecruitdiscrolquestype] c, 
                           [dbo].[trecruitdiscrolansdtls]f, 
                           [dbo].[trecruitcanbasicdtls] d, 
                           [dbo].[languages]e 
                    WHERE  a.[languageid] = b.[languageid] 
                           AND a.[questionid] = b.[quesserialno] 
                           AND b.[disquestypeid] = c.[id] 
                           AND a.[candidateid] = d.[candidateid] 
                           AND a.[languageid] = e.[id] 
                           AND a.answer = f.[number]
						   and a.[languageid]=f.[languageid]   
                           AND a.candidateid = @candidateid
                           AND [candidateattemexam] = @candidateattemexam
                           AND c.[disquestype] = 'SALMON' 
                    GROUP  BY c.[disquestype], 
                              a.candidateid)a
							  order by 
							  case [disquestype] when 'TIGER' then '0'
							   when 'CHAMELEON' then '1'
							   when 'TURTLE' then '2'
							   when 'EAGLE' then '3'
							   when 'SALMON' then '4'
							  else [disquestype]
							  end
							   

							  
end

GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: TBL_MLQ_ansmarks, TBL_MLQ_candidatelanguagemap, TBL_MLQ_empdtls, TBL_MLQ_examdtls, TBL_MLQ_quesdtls, tbl_RecruiterHR_Details, tempPsychometricTestMapping, test, trecruitcanbasicdtls, trecruitcandidateresgisterdtls, trecruitcandidatesignup */
/****** Object:  StoredProcedure [dbo].[proce_MLQ_dtls_Test]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[proce_MLQ_dtls_Test]             
                                       @action           NVARCHAR(100)=NULL,             
                                      @conquestype      NVARCHAR(100)=NULL,             
                                      @username         NVARCHAR(100)=NULL,             
                                      @activeflag       NVARCHAR(10)=NULL,             
                                      @conquestypeid    INT=NULL,             
                                      @languageid       INT=NULL,             
                                      @question         NVARCHAR(max)=NULL,             
                                      @questiondtlsid   INT=NULL,             
                                      @answer           NVARCHAR(max)=NULL,             
                                      @number           INT=NULL,             
                                      @answerdtlsid     INT=NULL,             
                                      @quesserialnonext INT=1,             
                                      @ollanguageid     INT=NULL,             
                                      @olquesserialno   INT=NULL,     
           @registrationnumber nvarchar(max)=NULL,     
            @MlqAllowExamUrl  NVARCHAR(max)=NULL,    
                                      @message          VARCHAR(500)=NULL output             
AS             
    DECLARE @empcode VARCHAR(100)             
    DECLARE @candidateid INT             
    DECLARE @anslanguageid INT             
    DECLARE @queslanguageid INT             
    DECLARE @countexamques INT             
    DECLARE @countexamattm INT             
    DECLARE @countexamattques INT             
    DECLARE @quesserialno INT             
    DECLARE @maplanid INT             
    DECLARE @countexamattmcan INT             
    DECLARE @findques INT             
    DECLARE @idd INT             
    DECLARE @attemptno INT             
    DECLARE @cattemptno INT             
    DECLARE @atteptestno INT             
 DECLARE @quesset INT             
    DECLARE @aquesset INT             
    DECLARE @createdtime DATETIME             
    DECLARE @cancreatedtime DATETIME             
    DECLARE @orquesserialno INT              
 DECLARE @sRanquesserialno int           
 DECLARE @empquesset INT               
 declare @empno int         ---ishita        
     
    
       
            
        
    
            
  BEGIN             
            
    SET @empquesset=1         
            
    SELECT  @quesserialno= Min([ranquesserialno])               
      FROM   [Recruitment].[dbo].[TBL_MLQ_quesdtls] p               
      WHERE  languageid = 5                          
     AND [queslanset] = @empquesset        
        
      set @languageid=5            
      set @maplanid=5            
            
      SELECT @candidateid = candidateid             
      FROM   [Recruitment].[dbo].[trecruitcandidatesignup]             
      WHERE  [username] = @username             
            
          
                  
                  
      --/////////////MLQ TEST START/////////////////          
      --=====================================================          
        -- Action: MLQquesansselect          
        -- Purpose: Select MLQ test question + answer details           
        --          with previous & next navigation support          
        --=====================================================        
        DECLARE @MLQquesset INT =1        
        DECLARE @MLQsserialno BIGINT        
        
    -----------------------------------------          
    IF @action = 'MLQquesansselect'          
        BEGIN          
            -------------------------------------------------          
            -- Get the Original Question Serial No        
            -------------------------------------------------          
            SELECT @MLQsserialno = quesserialno          
            FROM   TBL_MLQ_quesdtls           
            WHERE  queslanset = @MLQquesset;    
            
            -------------------------------------------------          
            -- Return Question + Navigation + Option Count + Candidate Answer        
     -------------------------------------------------          
            SELECT           
                   s.previousvalue,                     -- Previous Question Serial No          
                   s.ranquesserialno     AS quesserialno,          
                   s.question,                       -- Current Question          
                   s.nextvalue,                         -- Next Question Serial No          
                   p.noofques,                -- Total Questions in Set          
                   w.quescount           AS noofoption, -- No. of Answer Options          
                   ISNULL(ea.answer, 0)   AS givenanswer -- ✅ If no answer, return 0        
            FROM (          
                     SELECT           
                            LAG(p.ranquesserialno) OVER (ORDER BY p.ranquesserialno) AS previousvalue,          
                            LAG(p.question)        OVER (ORDER BY p.ranquesserialno) AS previousvalueques,          
                            p.ranquesserialno,          
                            p.question,          
                            p.quesserialno,          
                            LEAD(p.ranquesserialno) OVER (ORDER BY p.ranquesserialno) AS nextvalue,          
                            LEAD(p.question)        OVER (ORDER BY p.ranquesserialno) AS nextvalueques,          
                            p.languageid          
                     FROM   TBL_MLQ_quesdtls p          
                     WHERE  p.languageid = 5          
                            AND p.queslanset = @MLQquesset          
                  ) s          
             CROSS APPLY (          
                     SELECT           
                            languageid,           
                            COUNT(quesserialno) AS noofques          
                     FROM   TBL_MLQ_quesdtls          
                     WHERE  languageid = 5          
                            AND queslanset = @MLQquesset          
                     GROUP  BY languageid          
                  ) p          
             CROSS APPLY (          
                     SELECT           
                            questionno,           
                            COUNT(answerno) AS quescount          
                     FROM   TBL_MLQ_ansmarks          
                     WHERE  questionno = @MLQsserialno          
                     GROUP  BY questionno          
                  ) w          
             OUTER APPLY (   -- ✅ Last given answer by candidate        
                     SELECT TOP 1 t.answer        
                     FROM   TBL_MLQ_empdtls t        
                     WHERE  t.CandidateID = @CandidateID        
                            AND t.questionid = s.quesserialno        
                     ORDER BY t.createdon DESC        
                  ) ea          
             WHERE         
                   s.ranquesserialno = @quesserialnonext         
                   AND p.languageid = s.languageid;          
        END          
        
        
            
       -- IF @action = 'MLQquesansselect'          
       -- BEGIN          
       --     -------------------------------------------------          
       --     -- Get the Original Question Serial No        
       --     --SELECT * FROM TBL_MLQ_quesdtls        
       --     -------------------------------------------------          
                     
        
       --SELECT @MLQsserialno = quesserialno          
       --     FROM   TBL_MLQ_quesdtls   -- New MLQ Question table          
       --     WHERE  queslanset     = @MLQquesset          
       --            --AND ranquesserialno = @MLQsserialno;         
                   
       --     -------------------------------------------------          
       --     -- Return Question + Navigation + Option Count          
       --     -------------------------------------------------          
       --      SELECT           
       --           s.previousvalue,                     -- Previous Question Serial No          
       --           s.ranquesserialno     AS quesserialno,          
       --           s.question,                        -- Current Question          
       --           s.nextvalue,                         -- Next Question Serial No          
       --           p.noofques,                          -- Total Questions in Set          
       --           w.quescount           AS noofoption  -- No. of Answer Options          
       --     FROM (          
       --             SELECT           
       --                    LAG(p.ranquesserialno) OVER (ORDER BY p.ranquesserialno) AS previousvalue,          
       --                    LAG(p.question)        OVER (ORDER BY p.ranquesserialno) AS previousvalueques,          
       --                    p.ranquesserialno,          
       --                    p.question,          
       --                    p.quesserialno,          
       --                    LEAD(p.ranquesserialno) OVER (ORDER BY p.ranquesserialno) AS nextvalue,          
       --                    LEAD(p.question)        OVER (ORDER BY p.ranquesserialno) AS nextvalueques,          
       --                    p.languageid          
       --             FROM   TBL_MLQ_quesdtls p          
       --             WHERE  p.languageid = 5          
       --                    AND p.queslanset = @MLQquesset          
       --          ) s          
       --     CROSS APPLY (          
       --             SELECT           
       --                    languageid,           
       --                    COUNT(quesserialno) AS noofques          
       --             FROM   TBL_MLQ_quesdtls          
       --             WHERE  languageid = 5          
       --                    AND queslanset = @MLQquesset          
       --             GROUP  BY languageid          
       --          ) p          
       --     CROSS APPLY (          
       --             SELECT           
       --                    questionno,           
       --                    COUNT(answerno) AS quescount          
       --             FROM   TBL_MLQ_ansmarks  --  New MLQ Answer table          
       --             WHERE  questionno = @MLQsserialno          
       --             GROUP  BY questionno          
       --          ) w          
       --     WHERE         
       --           s.ranquesserialno =@quesserialnonext         
       --           AND p.languageid = s.languageid        
       -- END          
          
          
        --=====================================================          
        -- Action: MLQfirstquesansselect          
        -- Purpose: Fetch the first MLQ question + its answers          
        --=====================================================          
        IF @action = 'MLQfirstquesansselect'          
        BEGIN          
            -------------------------------------------------          
            -- Get the Original Question Serial No          
            -------------------------------------------------          
            SELECT @MLQsserialno = quesserialno          
            FROM   TBL_MLQ_quesdtls              -- ✅ MLQ Question Table          
            WHERE  queslanset     = @empquesset          
                   AND ranquesserialno = @quesserialno;          
          
            -------------------------------------------------          
            -- Return Answer Options for First Question          
            -------------------------------------------------          
            SELECT           
                   ans.answerno,          
                   ans.answer          
            FROM   TBL_MLQ_ansmarks ans          -- ✅ MLQ Answer Table          
            INNER JOIN TBL_MLQ_quesdtls qus          
                   ON ans.questionno = qus.quesserialno          
           WHERE  ans.languageid = 5          
                   AND qus.quesserialno = @MLQsserialno          
                   AND qus.queslanset = @empquesset;          
        END          
          
          
        --tesspeqempdtls → TBL_MLQ_empdtls          
          
        --tesspeqquesdtls → TBL_MLQ_quesdtls          
          
        --tesspeqexamdtls → TBL_MLQ_examdtls          
          
        --=====================================================          
        -- Action: MLQempdtlsinsert          
        -- Purpose: Insert or Update MLQ Employee Answer Details          
        --=====================================================          
        IF @action = 'MLQempdtlsinsert'         
        BEGIN          
            -------------------------------------------------          
            -- Get Current Attempt No          
                   
            -------------------------------------------------          
            SELECT @countexamattm = attemexam          
            FROM   TBL_MLQ_examdtls          
            WHERE  CandidateID = @candidateid          
                   AND finalsubmit <> 'Yes';          
          
                           
            -------------------------------------------------          
            -- Count Employee Attempt Records          
            -------------------------------------------------          
            SELECT @countexamattmcan = COUNT(CandidateID)          
            FROM   TBL_MLQ_examdtls          
            WHERE   CandidateID = @candidateid          
          
            -------------------------------------------------          
            -- Get Question Serial No          
            -------------------------------------------------          
            SELECT @MLQsserialno = quesserialno          
            FROM   TBL_MLQ_quesdtls          
            WHERE  queslanset     = @empquesset          
                   AND ranquesserialno = @questiondtlsid;          
          
     -------------------------------------------------          
            -- DELTER (first time)          
             --- DELETE from TBL_MLQ_empdtls        
            -------------------------------------------------          
    DELETE from TBL_MLQ_empdtls        
    where CandidateID=@candidateid       
    and questionid= @questiondtlsid      
      
          
            -------------------------------------------------          
            -- Insert Answer (first time)          
             --- DELETE from TBL_MLQ_empdtls        
            --select * from TBL_MLQ_empdtls        
            -------------------------------------------------          
            INSERT INTO TBL_MLQ_empdtls          
                        (CandidateID,          
                         exquesset,          
                         Serialno,          
                         languageid,          
                         questionid,          
                         answer,          
                         empattemexam,          
                         createdon,          
                         updatedon)          
            VALUES      (@candidateid,          
                         @empquesset,          
                         @questiondtlsid,          
                         @maplanid,          
                         @MLQsserialno,          
                         @number,          
                         @countexamattm,          
                         GETDATE(),          
                         GETDATE());          
          
            SET @message = 'MLQ Answer Details Successfully Inserted';          
          
            -------------------------------------------------          
            -- Update Exam Attempt Progress         
            --SELECT * FROM TBL_MLQ_examdtls        
            --DELETE TBL_MLQ_examdtls        
        
            -------------------------------------------------          
            SELECT @countexamattques = COUNT(questionid)     
            FROM   TBL_MLQ_empdtls          
            WHERE   CandidateID = @candidateid          
                   AND answer <> 0          
                   AND quesfinalsubmitques IS NULL;          
          
            IF @countexamattm IS NOT NULL          
            BEGIN          
                UPDATE TBL_MLQ_examdtls          
                SET    attemques = totalques - @countexamattques          
                WHERE   CandidateID = @candidateid          
                       AND finalsubmit = 'No';          
            END          
        END          
          
          
                
          
    --=====================================================        
        -- Action: MLQquesansselect        
        -- Purpose: Select MLQ test question + answer details         
        --          with previous & next navigation support         
        --          + include current remaining attempt questions        
        --=====================================================        
            
               
        --=====================================================          
        IF (@action = 'MLQcandidatelanguagemap')          
        BEGIN          
            -------------------------------------------------          
            -- 1. Remove existing mapping for this candidate          
            -------------------------------------------------          
            DELETE FROM [dbo].[TBL_MLQ_candidatelanguagemap]          
            WHERE CandidateID = @candidateid;          
          
            -------------------------------------------------          
            -- 2. Insert new mapping (default language = 5)          
            -------------------------------------------------          
            INSERT INTO [dbo].[TBL_MLQ_candidatelanguagemap]          
                        ([CandidateID], [languageid])          
            VALUES      (@candidateid, 5);          
          
            -------------------------------------------------          
            -- 3. Get mapped language id          
            -------------------------------------------------          
            SELECT @maplanid = languageid          
            FROM   [dbo].[TBL_MLQ_candidatelanguagemap]          
            WHERE  CandidateID = @candidateid;          
          
            -------------------------------------------------          
            -- 4. Count total MLQ questions for that language          
            -------------------------------------------------          
            SELECT @countexamques = COUNT([quesserialno])          
            FROM   [dbo].[TBL_MLQ_quesdtls]          
            WHERE  [languageid] = @maplanid;          
          
            -------------------------------------------------          
            -- 5. Count how many completed attempts          
            -------------------------------------------------          
            SELECT @attemptno = COUNT([attemexam])          
            FROM   [dbo].[TBL_MLQ_examdtls]          
            WHERE  [finalsubmit] = 'Yes'          
                   AND CandidateID = @candidateid;          
              -- select * from [TBL_MLQ_examdtls]      
      
            -------------------------------------------------          
            -- 6. Cleanup unfinished answers/exams          
            -------------------------------------------------          
            DELETE FROM [dbo].[TBL_MLQ_empdtls]          
            WHERE  [quesfinalsubmitques] IS NULL          
                   AND CandidateID = @candidateid;          
          
            DELETE FROM [dbo].[TBL_MLQ_examdtls]          
            WHERE  [finalsubmit] = 'No'          
                   AND CandidateID = @candidateid;          
          
            -------------------------------------------------          
            -- 7. Insert new MLQ exam attempt          
            -------------------------------------------------          
            INSERT INTO [dbo].[TBL_MLQ_examdtls]          
                        ([CandidateID], [languageid], [totalques],          
                         [attemques], [finalsubmit], [attemexam])          
            VALUES      (@candidateid, @maplanid, @countexamques,          
                         NULL, 'No', @attemptno + 1);          
        END          
       --=====================================================        
        -- Action: MLQgetremaining        
        -- Purpose: Return remaining questions (attemques)        
        --          for the current active MLQ exam        
        --=====================================================        
        IF @action = 'MLQgetremaining'        
        BEGIN        
            SELECT ISNULL(attemques,0) AS attemques        
            FROM   TBL_MLQ_examdtls        
            WHERE  CandidateID = @candidateid        
                    AND finalsubmit = 'No';        
        END        
   IF @Action = 'MLQfinalsubmit'      
  BEGIN      
   DECLARE @CandidateMail VARCHAR(MAX)    
   DECLARE @MailId VARCHAR(MAX)                                   
                                    
   DECLARE @mailSubject NVARCHAR(MAX)       
   DECLARE @CandidaFullName NVARCHAR(MAX)      
   DECLARE @PostName NVARCHAR(MAX)      
   DECLARE @RecruiterHRM NVARCHAR(MAX)    
      
   Declare @mailSubjectSubmit nvarchar(max)    
            -------------------------------------------------          
            -- Count Employee Attempt Records          
            -------------------------------------------------       
            SELECT @countexamattmcan = COUNT(CandidateID)          
            FROM   TBL_MLQ_examdtls          
            WHERE   CandidateID = @candidateid          
          
            -------------------------------------------------          
            -- Get Question Serial No          
            -------------------------------------------------          
            SELECT @MLQsserialno = quesserialno          
            FROM   TBL_MLQ_quesdtls          
            WHERE  queslanset     = @empquesset          
                   AND ranquesserialno = @questiondtlsid;          
          
    
          Select @CandidaFullName=(firstname+' '+middlename+' '+lastname)       
    from trecruitcanbasicdtls Where candidateid=@candidateid      
      
    SELECT @PostName=Appliedpost from trecruitcandidateresgisterdtls       
     where username=@username       
     -------------------------------------------------          
            -- DELTER (first time)          
             --- DELETE from TBL_MLQ_empdtls        
            -------------------------------------------------          
    DELETE from TBL_MLQ_empdtls        
    where CandidateID=@candidateid       
    and questionid= @questiondtlsid      
      
          
            -------------------------------------------------          
            -- Insert Answer (first time)            
            -------------------------------------------------          
            INSERT INTO TBL_MLQ_empdtls          
                        (CandidateID,          
                         exquesset,          
                         Serialno,          
                         languageid,          
                         questionid,          
                         answer,          
                         empattemexam,          
                         createdon,          
                         updatedon)          
            VALUES      (@candidateid,          
                         @empquesset,          
                         @questiondtlsid,          
                         @maplanid,          
                         @MLQsserialno,          
                         @number,          
                         @countexamattm,          
                         GETDATE(),          
                         GETDATE());         
            SET @message = 'MLQ Answer Details Successfully Inserted';      
         
         
      
    UPDATE TBL_MLQ_examdtls SET finalsubmit='Yes'       
    WHERE CandidateID=@candidateid      
     Update tempPsychometricTestMapping set MlqAllow='Completed'      
     where CandidateID=@candidateid      
      
     ------------------------------------------------------      
     ------------------send mail---------------------------      
     ------------------------------------------------------      
      
      --Select @RecruiterHRM = STRING_AGG(B.empemail, ';')   from tbl_RecruiterHR_Details A      
      --Inner join essp.dbo.Empbasic B on B.EMPNO=A.empno      
      --where B.empstatus='ACTIVE'     
  set @RecruiterHRM ='hr@mendine.in' 
  --set @RecruiterHRM ='saikat.mondal@iecsl.co.in'  
     -- Subject      
    SET @mailSubjectSubmit = 'MLQ Test Submission - ' + @CandidaFullName;      
   DECLARE @tableHTMLSubmit NVARCHAR(MAX)     
    -- HTML Body      
    SET @tableHTMLSubmit =       
    '<table style="font-size:16px; font-family:Tahoma; line-height:22px; width:600px;">      
       <tr>      
      <td>Dear Psychologist,</td>      
       </tr>      
       <tr><td style="height:15px;"></td></tr>      
      
       <tr>      
      <td>      
        This email is to inform you that <b>' + @CandidaFullName + '</b> applied for       
        <b>' + @PostName + '</b> department       
        has submitted the <b>Multifactor Leadership Questionnaire (MLQ)</b> test.      
      </td>      
       </tr>      
      
       <tr><td style="height:15px;"></td></tr>      
      
       <tr>      
      <td>      
        The results are now available for your review in the       
        <b>Candidate Report Section</b> of <i>ieHRMS</i>.      
      </td>      
       </tr>      
      
       <tr><td style="height:15px;"></td></tr>      
      
       <tr>      
      <td>      
        Please let me know if you need any additional information.      
      </td>      
       </tr>      
      
       <tr><td style="height:30px;"></td></tr>      
      
       <tr>      
      <td>      
        Thanks & Regards,<br/>      
        <i>ieHRMS System</i>      
      </td>      
       </tr>      
    </table>';      
      
      
    EXEC msdb.dbo.sp_send_dbmail        
                    @profile_name = 'Mendine_Recruitment_Profile'        
                    , @recipients = @RecruiterHRM        
                    , @subject = @mailSubjectSubmit        
                    , @body = @tableHTMLSubmit        
                    , @importance = 'HIGH'        
                   , @body_format = 'HTML'       
     ----------------Send Mail End-------------------------      
         
  END      
    
      
      --/////////////MLQ TEST END///////////////////          
            
  END          
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: Languages, TBL_MLQ_ansmarks, TBL_MLQ_candidatelanguagemap, TBL_MLQ_empdtls, TBL_MLQ_examdtls, TBL_MLQ_quesdtls, tempPsychometricTestMapping, test, trecruitcanbasicdtls, trecruitcandidatesignup, trecruiteqansmarks, trecruiteqcandidatedtls, trecruiteqcanlanguagemap, trecruiteqexamdtls, trecruiteqquesdtls, trecruiteqrandomques */
/****** Object:  StoredProcedure [dbo].[proceqmasdtls_Test]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[proceqmasdtls_Test]      @action           NVARCHAR(100)=NULL,     
                                      @conquestype      NVARCHAR(100)=NULL,     
                                      @username         NVARCHAR(100)=NULL,     
                                      @activeflag       NVARCHAR(10)=NULL,     
                                      @conquestypeid    INT=NULL,     
                                      @languageid       INT=NULL,     
                                      @question         NVARCHAR(max)=NULL,     
                                      @questiondtlsid   INT=NULL,     
                                      @answer           NVARCHAR(max)=NULL,     
                                      @number           INT=NULL,     
                                      @answerdtlsid     INT=NULL,     
                                      @quesserialnonext INT=NULL,     
                                      @ollanguageid     INT=NULL,     
                                      @olquesserialno   INT=NULL,     
                                      @message          VARCHAR(500)=NULL output     
AS     
    DECLARE @empcode VARCHAR(100)     
    DECLARE @candidateid INT     
    DECLARE @anslanguageid INT     
    DECLARE @queslanguageid INT     
    DECLARE @countexamques INT     
    DECLARE @countexamattm INT     
    DECLARE @countexamattques INT     
    DECLARE @quesserialno INT     
    DECLARE @maplanid INT     
    DECLARE @countexamattmcan INT     
    DECLARE @findques INT     
    DECLARE @idd INT     
    DECLARE @attemptno INT     
    DECLARE @cattemptno INT     
    DECLARE @atteptestno INT     
 DECLARE @quesset INT     
    DECLARE @aquesset INT     
    DECLARE @createdtime DATETIME     
    DECLARE @cancreatedtime DATETIME     
    DECLARE @orquesserialno INT     
    DECLARE @canquesset INT     
 DECLARE @sRanquesserialno int   
 DECLARE @empquesset INT       
 declare @empno int         ---ishita    
    
    
  BEGIN     
    
    SET @empquesset=1  
  
      set @languageid=5    
   set @maplanid=5    
      SELECT @empcode = empcode     
      FROM   essp.dbo.emp     
      WHERE  empemail = @username     
    
    
    
   SELECT @empno = empno     
      FROM   [essp].[dbo].[Empbasic]   ------ishita    
      WHERE  [empemail] = @username     
   and empstatus='ACTIVE'    
    
    
    
      SELECT @candidateid = candidateid     
      FROM   [Recruitment].[dbo].[trecruitcandidatesignup]     
      WHERE  [username] = @username     
    
      --SELECT @maplanid = languageid     
      --FROM   [Recruitment].[dbo].[trecruiteqcanlanguagemap] p     
      --WHERE  candidateid = @candidateid     
    
   --SELECT @createdtime = Max([createddate])     
   --   FROM   [Recruitment].[dbo].[trecruiteqrandomques] p     
   --   WHERE  languageid = @maplanid     
    
   SELECT @cancreatedtime = Max([createddate])     
      FROM   [Recruitment].[dbo].[trecruiteqrandomques] p     
         
    
      --SELECT @quesset = quesset     
      --FROM   [Recruitment].[dbo].[trecruiteqrandomques] p     
      --WHERE  languageid = @maplanid     
      --       AND createddate = @createdtime     
    
      SELECT @canquesset = quesset     
      FROM   [Recruitment].[dbo].[trecruiteqrandomques] p     
      WHERE   createddate = @cancreatedtime     
                
    
      IF @canquesset = 1     
        BEGIN     
            SET @aquesset=@canquesset + 1     
        END     
      ELSE IF @canquesset = 2     
       BEGIN     
            SET @aquesset=@canquesset + 1     
      END     
      ELSE IF @canquesset = 3     
       BEGIN     
           SET @aquesset=@canquesset-2     
       END     
    
    
      SELECT @countexamques = Count([question])     
      FROM   [Recruitment].[dbo].[trecruiteqquesdtls]    
      WHERE  [languageid] = 5     
   AND [queslanset] = @canquesset     
    
   SELECT @countexamattm = [attemexam]     
            FROM   [Recruitment].[dbo].[trecruiteqexamdtls]     
            WHERE  [candidateid] = @candidateid     
                   AND finalsubmit <> 'Yes'     
    
      SELECT @quesserialno = Min([ranquesserialno])     
      FROM   [Recruitment].[dbo].[trecruiteqquesdtls] p     
      WHERE  languageid = 5                
     AND [queslanset] = @canquesset     
    
    
     SELECT @orquesserialno = [quesserialno]     
      FROM   [Recruitment].[dbo].[trecruiteqquesdtls] ans     
      WHERE  [queslanset] = @canquesset     
             AND [ranquesserialno] = @questiondtlsid     
    
    --select * from [trecruiteqcandidatedtls]

      SELECT @findques = Count(questionid)     
      FROM   [Recruitment].[dbo].[trecruiteqcandidatedtls]     
      WHERE  candidateid = @candidateid     
             AND questionid = @orquesserialno     
             AND [quesfinalsubmitques] IS NULL     
    
    
      IF @action = 'EQcandidatelanguagemap'     
        BEGIN     
            DELETE FROM [dbo].[trecruiteqcanlanguagemap]    
            WHERE  [candidateid] = @candidateid     
    
            INSERT INTO [dbo].[trecruiteqcanlanguagemap]     
                        ([candidateid],     
                         [languageid])     
            VALUES      (@candidateid,     
                         5)     
        INSERT INTO [dbo].[trecruiteqrandomques]     
                        ([languageid],     
                         [quesset],     
                         [createddate],     
                         candidateid)     
            VALUES      (@languageid,     
                         @aquesset,     
                         Getdate(),     
                         @candidateid )     
    
       SELECT @maplanid = languageid     
            FROM   [Recruitment].[dbo].[trecruiteqcanlanguagemap] p     
            WHERE  candidateid = @candidateid     
    
      SELECT @countexamques = Count([question])     
      FROM   [Recruitment].[dbo].[trecruiteqquesdtls]     
       WHERE  [languageid] = @maplanid     
        AND [queslanset] = @canquesset     
    
      
    
            SELECT @attemptno = Count([attemexam])     
            FROM   [Recruitment].[dbo].[trecruiteqexamdtls]     
            WHERE  [finalsubmit] = 'Yes'     
                   AND candidateid = @candidateid     
    
            DELETE FROM [Recruitment].[dbo].[trecruiteqcandidatedtls]     
            WHERE  [quesfinalsubmitques] IS NULL     
                   AND candidateid = @candidateid     
    
            DELETE FROM [Recruitment].[dbo].[trecruiteqexamdtls]     
            WHERE  [finalsubmit] = 'No'     
                   AND candidateid = @candidateid     
    
            INSERT INTO [Recruitment].[dbo].[trecruiteqexamdtls]     
                        ([candidateid],     
                         [languageid],     
                         [totalques],     
                         [attemques],     
                         [finalsubmit],     
                         [attemexam])     
            VALUES      ( @candidateid,     
                          5,     
                          @countexamques,     
                          null,     
                          'No',     
                          @attemptno + 1 )     
        END     
    
      IF @action = 'EQquesansselect'     
        BEGIN     
    
   SELECT @orquesserialno=[quesserialno]          
  FROM [Recruitment].[dbo].[trecruiteqquesdtls]    
  where [Queslanset]=@canquesset and [Ranquesserialno]=@quesserialno    
    
    
             SELECT previousvalue,                       
                   ranquesserialno quesserialno,     
                   question,     
                   nextvalue,                        
                   noofques ,    
       quescount noofoption    
            FROM   (SELECT Lag(p.ranquesserialno)     
                             OVER (     
                               ORDER BY p.[ranquesserialno]) PreviousValue,     
                           Lag(p.question)     
                             OVER (     
                               ORDER BY p.[ranquesserialno]) PreviousValueques,     
                           p.ranquesserialno,     
                           p.question,     
 p.[quesserialno],    
                           Lead(p.ranquesserialno)     
                             OVER (     
                               ORDER BY p.[ranquesserialno]) NextValue,     
                           Lead(p.question)     
                             OVER (     
                               ORDER BY p.[ranquesserialno]) NextValueques,     
                           languageid     
                    FROM   [Recruitment].[dbo].[trecruiteqquesdtls] p     
       WHERE  languageid = 5                              
                           AND [queslanset] = @canquesset)s,     
                   (SELECT languageid,     
                           Count([quesserialno])noofques     
                    FROM   [Recruitment].[dbo].[trecruiteqquesdtls]     
                    WHERE  languageid = 5                                
                           AND [queslanset] = @canquesset    
                    GROUP  BY languageid) p ,(SELECT questionno,count([answerno])quescount    
          
                 FROM [Recruitment].[dbo].[trecruiteqansmarks]    
                             where questionno=@orquesserialno     
                              group by questionno)w    
            WHERE  ranquesserialno = @quesserialno     
                   AND p.languageid = s.languageid     
        END     
    
      IF @action = 'EQquesansselectnext'     
        BEGIN     
             SELECT @orquesserialno=[quesserialno]    
          
  FROM [Recruitment].[dbo].[trecruiteqquesdtls]    
  where [Queslanset]=@canquesset and [Ranquesserialno]=@quesserialnonext    
    
         
            SELECT previousvalue,     
                        
                   ranquesserialno quesserialno,     
                   question,     
                   nextvalue,     
                       
                   noofques,     
       quescount noofoption,    
                   CASE     
                     WHEN x.candidateid IS NULL THEN 0     
                     ELSE x.candidateid     
                   END             candidateid,     
                   CASE     
                     WHEN x.[answer] IS NULL THEN 0     
                     ELSE x.[answer]     
                   END             answer,     
                   CASE     
                     WHEN y.[attemques] BETWEEN 1 AND 100 THEN y.[attemques]     
                     ELSE y.[attemques]     
                   END             [attemques]     
            FROM   (SELECT Lag(p.ranquesserialno)     
                             OVER (     
                               ORDER BY p.[ranquesserialno]) PreviousValue,     
                           Lag(p.question)     
                             OVER (     
                               ORDER BY p.[ranquesserialno]) PreviousValueques,     
                           p.ranquesserialno,     
                           p.quesserialno,     
                           p.question,     
                           Lead(p.ranquesserialno)     
                             OVER (     
                               ORDER BY p.[ranquesserialno]) NextValue,     
                           Lead(p.question)     
                             OVER (     
                               ORDER BY p.[ranquesserialno]) NextValueques,     
                           languageid     
                    FROM   [Recruitment].[dbo].[trecruiteqquesdtls] p     
                    WHERE  languageid = 5     
                               
                           AND [queslanset] = @canquesset)s     
                   LEFT OUTER JOIN     
                   [Recruitment].[dbo].[trecruiteqcandidatedtls]     
                   x     
                                ON s.languageid = x.[languageid]     
                                   AND s.quesserialno = x.[questionid]     
                                   AND [quesfinalsubmitques] IS NULL     
                                   AND x.[candidateid] = @candidateid,     
                   (SELECT languageid,     
   count([quesserialno])noofques     
                    FROM   [Recruitment].[dbo].[trecruiteqquesdtls]     
                    WHERE  languageid = 5     
                               
                           AND [queslanset] = @canquesset     
                    GROUP  BY languageid) p, (SELECT questionno,count([answerno])quescount    
          
                 FROM [Recruitment].[dbo].[trecruiteqansmarks]    
                             where questionno=@orquesserialno    
                              group by questionno)w,    
                   [Recruitment].[dbo].[trecruiteqexamdtls] y     
            WHERE  ranquesserialno = @quesserialnonext     
                   AND p.languageid = s.languageid     
                   AND s.languageid = y.[languageid]     
                   AND y.[candidateid] = @candidateid     
                   AND [finalsubmit] = 'No'     
        END     
    
      IF @action = 'EQansselect'     
        BEGIN     
    
  SELECT @orquesserialno = [quesserialno]     
            FROM   [Recruitment].[dbo].[trecruiteqquesdtls] ans     
            WHERE  [queslanset] = @canquesset     
                   AND [ranquesserialno] = @quesserialnonext     
    
            SELECT [answerno],     
                   [answer],     
                   language     
            FROM   [Recruitment].[dbo].[trecruiteqansmarks] ans,     
                   [Recruitment].[dbo].[languages] lan,[Recruitment].[dbo].[trecruiteqquesdtls] qus     
            WHERE  ans.[languageid] = lan.[id]     
                   AND lan.[id] = 5    
       and ans.[questionno]=qus.[quesserialno]    
       and qus.[quesserialno]=@orquesserialno    
       and [queslanset] = @canquesset    
           
        END     
    
      IF @action = 'EQolquesansselect'     
        BEGIN     
         SELECT @orquesserialno = [quesserialno]     
            FROM   [Recruitment].[dbo].[trecruiteqquesdtls] ans     
            WHERE  [queslanset] = @canquesset     
                   AND [ranquesserialno] = @questiondtlsid     
    
            SELECT [question]     
            FROM   [Recruitment].[dbo].[trecruiteqquesdtls]     
            WHERE  languageid = 5    
                   AND ranquesserialno = @olquesserialno     
                   AND [queslanset] = @canquesset     
    
            SELECT [answerno],     
                   [answer]     
            FROM   [Recruitment].[dbo].[trecruiteqansdtls] ans,    
   [Recruitment].[dbo].[trecruiteqquesdtls] qus     
            WHERE  ans.[languageid] = 5    
   and ans.[questionno]=qus.[quesserialno]    
   and qus.[quesserialno]=@orquesserialno    
        END     
    
   IF @action = 'EQfirstquesansselect'     
        BEGIN     
            
   SELECT @orquesserialno=[quesserialno]          
  FROM [Recruitment].[dbo].[trecruiteqquesdtls]    
  where [Queslanset]=@canquesset and [Ranquesserialno]=@quesserialno    
    
            SELECT [answerno],     
                   [answer]     
            FROM   [Recruitment].[dbo].trecruiteqansmarks ans, [Recruitment].[dbo].trecruiteqquesdtls  qus     
            WHERE  ans.[languageid] = 5    
   and ans.[questionno]=qus.[quesserialno]    
   and qus.[quesserialno]=@orquesserialno    
   AND [queslanset] = @canquesset     
        END     
         
    
      IF @action = 'EQcandtlsinsert'     
         AND @findques = 0     
        BEGIN     
            SELECT @countexamattm = [attemexam]     
            FROM   [Recruitment].[dbo].[trecruiteqexamdtls]     
            WHERE  [candidateid] = @candidateid     
                   AND finalsubmit <> 'Yes'     
    
            SELECT @countexamattmcan = Count([candidateid])     
            FROM   [Recruitment].[dbo].[trecruiteqexamdtls]     
            WHERE  [candidateid] = @candidateid     
    
   SELECT @orquesserialno = [quesserialno]     
            FROM   [Recruitment].[dbo].[trecruiteqquesdtls] ans     
            WHERE  [queslanset] = @canquesset     
                   AND [ranquesserialno] = @questiondtlsid     
    
           BEGIN     
             INSERT INTO [Recruitment].[dbo].[trecruiteqcandidatedtls]     
                            ([candidateid],     
                             exquesset,     
        [Serialno],    
                             [languageid],     
                             [questionid],     
                             [answer],     
                             candidateattemexam,     
                             [createdon],     
                             [updatedon])     
                VALUES      ( @candidateid,     
                              @canquesset,     
         @questiondtlsid,    
                              @maplanid,     
                              @orquesserialno,     
                              @number,     
                              @countexamattm,     
                              Getdate(),     
           Getdate() )     
    
           SET @message='Answer Details Successfully Inserted'     
            END     
    
            SELECT @countexamattques = Count([questionid])     
            FROM   [Recruitment].[dbo].[trecruiteqcandidatedtls]     
            WHERE  candidateid = @candidateid     
                   AND answer <> 0     
                   AND quesfinalsubmitques IS NULL     
    
            IF @countexamattm IS NOT NULL     
              BEGIN     
                  UPDATE [Recruitment].[dbo].[trecruiteqexamdtls]     
                  SET    [attemques] = [totalques] - @countexamattques     
                  WHERE  candidateid = @candidateid     
                         AND finalsubmit = 'No'     
              END     
        END     
    
      IF @action = 'EQcandtlsinsert'     
         AND @findques > 0     
        BEGIN     
            SELECT @countexamattm = [attemexam]     
            FROM   [Recruitment].[dbo].[trecruiteqexamdtls]     
            WHERE  [candidateid] = @candidateid     
                   AND finalsubmit <> 'Yes'     
    
           SELECT @orquesserialno = [quesserialno]     
            FROM   [Recruitment].[dbo].[trecruiteqquesdtls] ans     
            WHERE  [queslanset] = @canquesset     
                   AND [ranquesserialno] = @questiondtlsid     
    
            UPDATE [Recruitment].[dbo].[trecruiteqcandidatedtls]     
            SET    [answer] = @number,     
                   [updatedon] = Getdate()     
            WHERE  [candidateid] = @candidateid     
                   AND [questionid] = @orquesserialno      
                   AND [quesfinalsubmitques] IS NULL     
    
            SET @message='Answer Details Successfully Updated'     
    
            SELECT @countexamattques = Count([questionid])     
            FROM   [Recruitment].[dbo].[trecruiteqcandidatedtls]     
            WHERE  candidateid = @candidateid     
                   AND answer <> 0     
                   AND quesfinalsubmitques IS NULL     
    
            IF @countexamattm IS NOT NULL     
              BEGIN     
                  UPDATE [Recruitment].[dbo].[trecruiteqexamdtls]     
                  SET    [attemques] = [totalques] - @countexamattques     
                  WHERE  candidateid = @candidateid     
                         AND finalsubmit = 'No'     
              END     
        END     
    
      IF @action = 'Finalsubmit'     
        BEGIN     
            UPDATE [Recruitment].[dbo].[trecruiteqexamdtls]     
            SET    [finalsubmit] = 'Yes'     
            WHERE  candidateid = @candidateid     
    
            UPDATE [Recruitment].[dbo].[trecruitcanbasicdtls]     
            SET    [eqallow] = 'Completed'     
            WHERE  candidateid = @candidateid     
    
    
   UPDATE [essp].[dbo].[temppsychometrictestmapping]     
            SET    [EQTest] = 'Completed'         ------ishita    
            WHERE  empno = @empno    
    
    
            UPDATE [dbo].[trecruiteqcandidatedtls]     
            SET    [quesfinalsubmitques] = 'F'     
            WHERE  candidateid = @candidateid     
        END     
    
      IF @action = 'Eqansqnoselect'     
        BEGIN     
            SELECT @atteptestno = [attemexam]     
            FROM   [Recruitment].[dbo].[trecruiteqexamdtls]     
            WHERE  [finalsubmit] = 'No'      
                   AND [candidateid] = @candidateid     
    
            SELECT [Serialno][questionid]     
            FROM   [Recruitment].[dbo].[trecruiteqcandidatedtls]     
            WHERE  [answer] > 0     
                   AND [candidateattemexam] = @atteptestno     
                   AND [candidateid] = @candidateid     
        END   
          
          
      --/////////////MLQ TEST START/////////////////  
      --=====================================================  
        -- Action: MLQquesansselect  
        -- Purpose: Select MLQ test question + answer details   
        --          with previous & next navigation support  
        --=====================================================
        DECLARE @MLQquesset BIGINT =1
        DECLARE @MLQsserialno BIGINT

      SELECT @MLQsserialno = Min([Ranquesserialno])     
      FROM   TBL_MLQ_quesdtls p     
      WHERE  languageid = 5                
     AND [queslanset] = @canquesset     
    
    
        IF @action = 'MLQquesansselect'  
        BEGIN  
            -------------------------------------------------  
            -- Get the Original Question Serial No
            --SELECT * FROM TBL_MLQ_quesdtls
            -------------------------------------------------  
            SELECT @MLQsserialno = quesserialno  
            FROM   TBL_MLQ_quesdtls   -- New MLQ Question table  
            WHERE  queslanset     = @MLQquesset  
                   --AND ranquesserialno = @MLQsserialno;  
  
            -------------------------------------------------  
            -- Return Question + Navigation + Option Count  
            -------------------------------------------------  
            SELECT   
                  s.previousvalue,                     -- Previous Question Serial No  
                  s.ranquesserialno     AS quesserialno,  
                  s.question,                          -- Current Question  
                  s.nextvalue,                         -- Next Question Serial No  
                  p.noofques,                          -- Total Questions in Set  
                  w.quescount           AS noofoption  -- No. of Answer Options  
            FROM (  
                    SELECT   
                           LAG(p.ranquesserialno) OVER (ORDER BY p.ranquesserialno) AS previousvalue,  
                           LAG(p.question)        OVER (ORDER BY p.ranquesserialno) AS previousvalueques,  
                           p.ranquesserialno,  
                           p.question,  
                           p.quesserialno,  
                           LEAD(p.ranquesserialno) OVER (ORDER BY p.ranquesserialno) AS nextvalue,  
                           LEAD(p.question)        OVER (ORDER BY p.ranquesserialno) AS nextvalueques,  
                           p.languageid  
                    FROM   TBL_MLQ_quesdtls p  
                    WHERE  p.languageid = 5  
                           AND p.queslanset = @empquesset  
                 ) s  
            CROSS APPLY (  
                    SELECT   
                           languageid,   
                           COUNT(quesserialno) AS noofques  
                    FROM   TBL_MLQ_quesdtls  
                    WHERE  languageid = 5  
                           AND queslanset = @empquesset  
                    GROUP  BY languageid  
                 ) p  
            CROSS APPLY (  
                    SELECT   
                           questionno,   
                           COUNT(answerno) AS quescount  
                    FROM   TBL_MLQ_ansmarks  --  New MLQ Answer table  
                    WHERE  questionno = @MLQsserialno  
                    GROUP  BY questionno  
                 ) w  
            WHERE s.ranquesserialno = @quesserialno  
                  AND p.languageid = s.languageid;  
        END  
  
  
        --=====================================================  
        -- Action: MLQfirstquesansselect  
        -- Purpose: Fetch the first MLQ question + its answers  
        --=====================================================  
        IF @action = 'MLQfirstquesansselect'  
        BEGIN  
            -------------------------------------------------  
            -- Get the Original Question Serial No  
            -------------------------------------------------  
            SELECT @MLQsserialno = quesserialno  
            FROM   TBL_MLQ_quesdtls              -- ✅ MLQ Question Table  
            WHERE  queslanset     = @empquesset  
                   AND ranquesserialno = @quesserialno;  
  
            -------------------------------------------------  
            -- Return Answer Options for First Question  
            -------------------------------------------------  
            SELECT   
                   ans.answerno,  
                   ans.answer  
            FROM   TBL_MLQ_ansmarks ans          -- ✅ MLQ Answer Table  
            INNER JOIN TBL_MLQ_quesdtls qus  
                   ON ans.questionno = qus.quesserialno  
            WHERE  ans.languageid = 5  
                   AND qus.quesserialno = @MLQsserialno  
                   AND qus.queslanset = @empquesset;  
        END  
  
  
        --tesspeqempdtls → TBL_MLQ_empdtls  
  
        --tesspeqquesdtls → TBL_MLQ_quesdtls  
  
        --tesspeqexamdtls → TBL_MLQ_examdtls  
  
        --=====================================================  
        -- Action: MLQempdtlsinsert  
        -- Purpose: Insert or Update MLQ Employee Answer Details  
        --=====================================================  
        IF @action = 'MLQempdtlsinsert' 
        BEGIN  
            -------------------------------------------------  
            -- Get Current Attempt No  
           
            -------------------------------------------------  
            SELECT @countexamattm = attemexam  
            FROM   TBL_MLQ_examdtls  
            WHERE  CandidateID = @candidateid  
                   AND finalsubmit <> 'Yes';  
  
                   
            -------------------------------------------------  
            -- Count Employee Attempt Records  
            -------------------------------------------------  
            SELECT @countexamattmcan = COUNT(CandidateID)  
            FROM   TBL_MLQ_examdtls  
            WHERE   CandidateID = @candidateid  
  
            -------------------------------------------------  
            -- Get Question Serial No  
            -------------------------------------------------  
            SELECT @MLQsserialno = quesserialno  
            FROM   TBL_MLQ_quesdtls  
            WHERE  queslanset     = @empquesset  
                   AND ranquesserialno = @questiondtlsid;  
  
            -------------------------------------------------  
            -- Insert Answer (first time)  
            --DELETE from TBL_MLQ_empdtls
            --select * from TBL_MLQ_empdtls
            -------------------------------------------------  
            INSERT INTO TBL_MLQ_empdtls  
                        (CandidateID,  
                         exquesset,  
                         Serialno,  
                         languageid,  
                         questionid,  
                         answer,  
                         empattemexam,  
                         createdon,  
                         updatedon)  
            VALUES      (@candidateid,  
                         @empquesset,  
                         @questiondtlsid,  
                         @maplanid,  
                         @MLQsserialno,  
                         @number,  
                         @countexamattm,  
                         GETDATE(),  
                         GETDATE());  
  
            SET @message = 'MLQ Answer Details Successfully Inserted';  
  
            -------------------------------------------------  
            -- Update Exam Attempt Progress 
            --SELECT * FROM TBL_MLQ_examdtls
            --DELETE TBL_MLQ_examdtls

            -------------------------------------------------  
            SELECT @countexamattques = COUNT(questionid)  
            FROM   TBL_MLQ_empdtls  
            WHERE   CandidateID = @candidateid  
                   AND answer <> 0  
                   AND quesfinalsubmitques IS NULL;  
  
            IF @countexamattm IS NOT NULL  
            BEGIN  
                UPDATE TBL_MLQ_examdtls  
                SET    attemques = totalques - @countexamattques  
                WHERE   CandidateID = @candidateid  
                       AND finalsubmit = 'No';  
            END  
        END  
  
  
        --=====================================================  
        -- Action: MLQempdtlsinsert (Update Answer if Exists)  
        --=====================================================  
        IF @action = 'MLQempdtlsinsert' --AND @findques > 0  
        BEGIN  
            -------------------------------------------------  
            -- Get Current Attempt No  
            -------------------------------------------------  
            SELECT @countexamattm = attemexam  
            FROM   TBL_MLQ_examdtls  
            WHERE  CandidateID = @candidateid  
                   AND finalsubmit <> 'Yes';  
  
            -------------------------------------------------  
            -- Get Question Serial No  
            -------------------------------------------------  
            SELECT @MLQsserialno = quesserialno  
            FROM   TBL_MLQ_quesdtls  
            WHERE  queslanset     = @empquesset  
                   AND ranquesserialno = @questiondtlsid;  
  
            -------------------------------------------------  
            -- Update Existing Answer  
            -------------------------------------------------  
            UPDATE TBL_MLQ_empdtls  
            SET    answer   = @number,  
                   updatedon = GETDATE()  
            WHERE  CandidateID = @candidateid  
                   AND questionid = @MLQsserialno  
                   AND quesfinalsubmitques IS NULL;  
  
            SET @message = 'MLQ Answer Details Successfully Updated';  
  
            -------------------------------------------------  
            -- Update Exam Attempt Progress  
            -------------------------------------------------  
            SELECT @countexamattques = COUNT(questionid)  
            FROM   TBL_MLQ_empdtls  
            WHERE  CandidateID = @candidateid  
                   AND answer <> 0  
                   AND quesfinalsubmitques IS NULL;  
  
            IF @countexamattm IS NOT NULL  
            BEGIN  
                UPDATE TBL_MLQ_examdtls  
                SET    attemques = totalques - @countexamattques  
                WHERE   CandidateID = @candidateid  
                       AND finalsubmit = 'No';  
            END  
        END  
  
    --=====================================================
        -- Action: MLQquesansselect
        -- Purpose: Select MLQ test question + answer details 
        --          with previous & next navigation support 
        --          + include current remaining attempt questions
        --=====================================================
        IF @action = 'MLQquesansselect'
        BEGIN
            -------------------------------------------------
            -- Get the Original Question Serial No
            -------------------------------------------------
            SELECT @MLQsserialno = quesserialno
            FROM   TBL_MLQ_quesdtls   -- MLQ Question table
            WHERE  queslanset      = @empquesset
                   AND ranquesserialno = @quesserialno;

                --   SELECT * FROM TBL_MLQ_quesdtls
                --SELECT * FROM TBL_MLQ_ansmarks
            -------------------------------------------------
            -- Return Question + Navigation + Option Count + Remaining Questions
            -------------------------------------------------
            SELECT 
                  s.previousvalue,                    -- Previous Question Serial No  
                  s.ranquesserialno  AS quesserialno, -- Current Random Question Serial  
                  s.question,                         -- Question Text  
                  s.nextvalue,                        -- Next Question Serial No  
                  p.noofques,                         -- Total Questions in Set  
                  w.quescount        AS noofoption,   -- No. of Answer Options  
                  ISNULL(e.attemques, 0) AS attemques -- ✅ Remaining Questions for this attempt
            FROM (
                    SELECT 
                        LAG(p.ranquesserialno) OVER (ORDER BY p.ranquesserialno) AS previousvalue,
                        p.ranquesserialno,
                        p.question,
                        p.quesserialno,
                        LEAD(p.ranquesserialno) OVER (ORDER BY p.ranquesserialno) AS nextvalue,
                        p.languageid
                    FROM   TBL_MLQ_quesdtls p
                    WHERE  p.languageid = 5
                           AND p.queslanset = @empquesset
                 ) s
            CROSS APPLY (
                    SELECT 
                           languageid, 
                           COUNT(quesserialno) AS noofques
                    FROM   TBL_MLQ_quesdtls
                    WHERE  languageid = 5
                           AND queslanset = @empquesset
                    GROUP BY languageid
                 ) p
            CROSS APPLY (
                    SELECT 
                           questionno, 
                           COUNT(answerno) AS quescount
                    FROM   TBL_MLQ_ansmarks   -- Answer table
                    WHERE  questionno = @MLQsserialno
                    GROUP  BY questionno
                 ) w
            LEFT JOIN TBL_MLQ_examdtls e
                   ON e.CandidateID = @candidateid
                  AND e.finalsubmit = 'No'  -- current attempt only
            WHERE s.ranquesserialno = @quesserialno
                  AND p.languageid = s.languageid;
        END
       
        --=====================================================  
        IF (@action = 'MLQcandidatelanguagemap')  
        BEGIN  
            -------------------------------------------------  
            -- 1. Remove existing mapping for this candidate  
            -------------------------------------------------  
            DELETE FROM [dbo].[TBL_MLQ_candidatelanguagemap]  
            WHERE CandidateID = @candidateid;  
  
            -------------------------------------------------  
            -- 2. Insert new mapping (default language = 5)  
            -------------------------------------------------  
            INSERT INTO [dbo].[TBL_MLQ_candidatelanguagemap]  
                        ([CandidateID], [languageid])  
            VALUES      (@candidateid, 5);  
  
            -------------------------------------------------  
            -- 3. Get mapped language id  
            -------------------------------------------------  
            SELECT @maplanid = languageid  
            FROM   [dbo].[TBL_MLQ_candidatelanguagemap]  
            WHERE  CandidateID = @candidateid;  
  
            -------------------------------------------------  
            -- 4. Count total MLQ questions for that language  
            -------------------------------------------------  
            SELECT @countexamques = COUNT([quesserialno])  
            FROM   [dbo].[TBL_MLQ_quesdtls]  
            WHERE  [languageid] = @maplanid;  
  
            -------------------------------------------------  
            -- 5. Count how many completed attempts  
            -------------------------------------------------  
            SELECT @attemptno = COUNT([attemexam])  
            FROM   [dbo].[TBL_MLQ_examdtls]  
            WHERE  [finalsubmit] = 'Yes'  
                   AND CandidateID = @candidateid;  
 
            -------------------------------------------------  
            -- 6. Cleanup unfinished answers/exams  
            -------------------------------------------------  
            DELETE FROM [dbo].[TBL_MLQ_empdtls]  
            WHERE  [quesfinalsubmitques] IS NULL  
                   AND CandidateID = @candidateid;  
  
            DELETE FROM [dbo].[TBL_MLQ_examdtls]  
            WHERE  [finalsubmit] = 'No'  
                   AND CandidateID = @candidateid;  
  
            -------------------------------------------------  
            -- 7. Insert new MLQ exam attempt  
            -------------------------------------------------  
            INSERT INTO [dbo].[TBL_MLQ_examdtls]  
                        ([CandidateID], [languageid], [totalques],  
                         [attemques], [finalsubmit], [attemexam])  
            VALUES      (@candidateid, @maplanid, @countexamques,  
                         NULL, 'No', @attemptno + 1);  
        END  
       --=====================================================
        -- Action: MLQgetremaining
        -- Purpose: Return remaining questions (attemques)
        --          for the current active MLQ exam
        --=====================================================
        IF @action = 'MLQgetremaining'
        BEGIN
            SELECT ISNULL(attemques,0) AS attemques
            FROM   TBL_MLQ_examdtls
            WHERE  CandidateID = @candidateid
                    AND finalsubmit = 'No';
        END
      --/////////////MLQ TEST END///////////////////  
    
  END  
GO

/* Functional group: 06_PSYCHOMETRIC_TESTS_AND_REPORTS; referenced grouped tables: test, trecruitcanbasicdtls, trecruitdiscrolecanlanguagemap, trecruittraker, trecruittrakeruploadfilefinal, trecruittrakeruploadfileone, trecruittrakeruploadfilethree, trecruittrakeruploadfiletwo */
/****** Object:  StoredProcedure [dbo].[procinserttrakerform_temp]    Script Date: 15-08-2026 12:36:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procinserttrakerform_temp]                                   
                                 
                                 
                                  
           -- @userName      nvarchar(max)=NULL,                              
                              
            @candidateno                   VARCHAR(100)=NULL,                                                    
            @Departmentdivision            VARCHAR(100)=NULL,                                   
            @HeadQ                         VARCHAR(500)=NULL,                                   
            @candidatename                 VARCHAR(500)=NULL,                              
    @postname                      VARCHAR(100)=NULL,                              
            @source                        VARCHAR(500)=NULL,                                   
            @STARTDATE                     VARCHAR(500)=NULL,                                   
            @CVSelected                    VARCHAR(10)=NULL,                                   
            @roneinterviewdate             VARCHAR(500)=NULL,                                   
            @roneinterviewernameone        VARCHAR(300)=NULL,                                   
            @roneinterviewernametwo        VARCHAR(300)=NULL,                                   
   @roneinterviewenddate          VARCHAR(500)=NULL,                                
            @frintervieweronerfile         VARBINARY(max)=NULL,                                   
            @frinterviewertworfile         VARBINARY(max)=NULL,                                   
            @frintervieweroneContentType   VARCHAR(50)=NULL,                                   
            @frinterviewertwoContentType   VARCHAR(50)=NULL,                                   
            @frintervieweronefilename      VARCHAR(50)=NULL,                                   
            @frinterviewertwofilename      VARCHAR(50) =NULL,                                  
   @roneselect      VARCHAR(10)=NULL,                                  
            @rtwointerviewdate             VARCHAR(300)=NULL,                                  
            @rtwointerviewernameone        VARCHAR(300)=NULL,                                  
            @rtwointerviewernametwo        VARCHAR(300)=NULL,                                  
   @rtwointerviewenddate             VARCHAR(300)=NULL,                                  
   @srintervieweronerfile         VARBINARY(max)=NULL,                                   
            @srinterviewertworfile         VARBINARY(max)=NULL,                                   
            @srintervieweroneContentType   VARCHAR(50)=NULL,                                   
            @srinterviewertwoContentType   VARCHAR(50)=NULL,                                   
            @srintervieweronefilename      VARCHAR(50)=NULL,                                   
            @srinterviewertwofilename      VARCHAR(50) =NULL,                                    
   @rtwoselect                    VARCHAR(10)=NULL,                                  
            @rthreeinterviewdate           VARCHAR(300)=NULL,                                  
            @rthreeinterviewernameone      VARCHAR(300)=NULL,                                  
            @rthreeinterviewernametwo      VARCHAR(300)=NULL,                                  
   @rthreeinterviewenddate           VARCHAR(300)=NULL,                                  
   @trintervieweronerfile         VARBINARY(max)=NULL,                                   
            @trinterviewertworfile         VARBINARY(max)=NULL,                                   
            @trintervieweroneContentType   VARCHAR(50)=NULL,                                   
            @trinterviewertwoContentType   VARCHAR(50)=NULL,                                   
            @trintervieweronefilename      VARCHAR(50)=NULL,                                   
            @trinterviewertwofilename      VARCHAR(50) =NULL,                                    
   @rthreeselect                  VARCHAR(10)=NULL,                                  
            @rfinalinterviewdate           VARCHAR(300)=NULL,                                  
            @rfinalinterviewernameone      VARCHAR(300)=NULL,                                
            @rfinalinterviewernametwo      VARCHAR(300)=NULL,                      
 --                          
 -- Selected Candidate Confirm Date Final Interview Pending Date                     
                    
 --EXEC dbo.proc_CandidateNotification @CanNotifyStatus,@regno,@sltCandConfirmDate,@finalinterviewdate,@finalinterviewStartTime                      
 --,@finalinterviewEndTime,@rfinalinterviewendVenue,@finalInterviewPandingDate;                       
-- @status nvarchar(max),                                        
--@registrationnumber nvarchar(max),                         
-- @sltCandConfirmDate varchar(300)=NULL,                              
-- @finalinterviewdate varchar(300)=NULL,                        
-- @finalinterviewStartTime   VARCHAR(400)=NULL,                          
-- @finalinterviewEndTime   VARCHAR(400)=NULL,                        
--@rfinalinterviewendVenue     VARCHAR(MAX)=NULL,                        
--@finalInterviewPandingDate varchar(400)=NULL                        
                      
  @CanNotifyStatus      nvarchar(max)=NULL,                       
  @regno    nvarchar(max)=NULL,                      
  @sltCandConfirmDate varchar(300)=NULL,                      
  @finalinterviewdate varchar(300)=NULL,                      
  @finalinterviewStartTime   VARCHAR(400)=NULL,                      
  @finalinterviewEndTime   VARCHAR(400)=NULL,                      
  @finalinterviewendVenue     VARCHAR(MAX)=NULL,                      
  @finalInterviewPandingDate varchar(300)=NULL,                    
  @candidateAfterNoResponseDate nvarchar(max)=null,               
  @candUndrInterviewProcessDate nvarchar(max)=null,            
                       
 @rfinalinterviewenddate           VARCHAR(300)=NULL,                                      
   @firintervieweronerfile        VARBINARY(max)=NULL,                                   
            @firinterviewertworfile        VARBINARY(max)=NULL,                                   
            @firintervieweroneContentType  VARCHAR(50)=NULL,                                   
          @firinterviewertwoContentType  VARCHAR(50)=NULL,                                   
            @firintervieweronefilename     VARCHAR(50)=NULL,                                   
            @firinterviewertwofilename     VARCHAR(50) =NULL,                                  
   @firselect                     VARCHAR(10)=NULL,                                  
   @DOO                           VARCHAR(300)=NULL,                                  
   @DOJ                           VARCHAR(300)=NULL,                                  
   @EmployeeCode                  VARCHAR(300)=NULL,                                  
   @Remarks                       VARCHAR(300)=NULL,                                  
   @CompletionStatus             VARCHAR(300)=NULL,                                  
   @timetaken                     VARCHAR(300)=NULL,                                  
   @discrollallow                 VARCHAR(50)=NULL,                                   
   @conflictallow                 VARCHAR(50)=NULL,                                   
   @iqallow                       VARCHAR(50)=NULL,                                   
   @eqallow                       VARCHAR(50)=NULL ,                                  
   @docuploadallow                VARCHAR(50)=NULL ,                                  
   @bigfiveallow                  VARCHAR(50)=NULL,                                  
   @firoballow                    VARCHAR(50)=NULL,                                  
   @myersbriggsallow               VARCHAR(50)=NULL,                                  
   @rotterlocusofcontrolallow      VARCHAR(50)=NULL,                                  
   @personalitystyleinventoryallow VARCHAR(50)=NULL,   
     
   @PersonalDtlsResubmitStatus varchar(50)=Null,  
   @FamilyLanguageDtlsResubmitStatus varchar(50)=Null,  
   @EducationDtlsResubmitStatus varchar(50)=Null,  
   @EmploymentHistoryDtlsResubmitStatus varchar(50)=Null,  
   @AllFormOpenResubmitStatus varchar(50)=Null  
  
  -- @resubmitStatus varchar(50)=NULL    
AS                                   
  BEGIN                              
      DECLARE @postid INT                                   
      DECLARE @locid INT                                   
      DECLARE @candidateid INT       
   declare @cancount int                                  
   declare @empcount int     
   DECLARE @resubmittedStatus varchar(50)  
     
  if(@PersonalDtlsResubmitStatus IS NOT NULL  
   OR @FamilyLanguageDtlsResubmitStatus IS NOT NULL  
    OR @EducationDtlsResubmitStatus IS NOT NULL  
    OR @EmploymentHistoryDtlsResubmitStatus IS NOT NULL  
    OR @AllFormOpenResubmitStatus IS NOT NULL)                         
   Begin  
    SET @resubmittedStatus='RESUBMIT'  
   End  
     ELSE  
     BEGIN  
     SET @resubmittedStatus='NEW'  
     END  
 select                                     
   @postid = [postid],                                   
      @locid = [locid]            
   from [dbo].[vw_recruittracker]                                   
   where  [postname] = @postname                                  
                                  
   SELECT @cancount=count([referenceno])                                                         FROM   [dbo].[trecruittraker]                                   
      WHERE  [referenceno] = @candidateno                                    
                   
     select @candidateid=[candidateid] FROM [dbo].[trecruitcanbasicdtls]                                  
     where registrationnumber=@candidateno                                  
                                 
  select @empcount=count([candidateid]) from [dbo].[trecruitdiscrolecanlanguagemap]                             
  where candidateid=@candidateid                                   
                                  
 --Notify to the email                               
if(@CanNotifyStatus <>'')                              
Begin                            
 --If not((select CanNotifyStatus from [trecruitcanbasicdtls]               
 --   where registrationnumber=@regno)=@CanNotifyStatus         
 --   and(select CanNotifyStatus from [trecruitcanbasicdtls]               
 --   where registrationnumber=@regno)=NULL)              
 -- Begin              
 --  EXEC dbo.proc_CandidateNotification @CanNotifyStatus,@regno,@sltCandConfirmDate,@finalinterviewdate,@finalinterviewStartTime,@finalinterviewEndTime,@finalinterviewendVenue,@finalInterviewPandingDate,@candidateAfterNoResponseDate,@candUndrInterviewProcessDate;              
 -- end                        
  IF (   (SELECT CanNotifyStatus     FROM [trecruitcanbasicdtls]           WHERE registrationnumber = @regno) IS NULL   OR    NOT   (SELECT CanNotifyStatus     FROM [trecruitcanbasicdtls]           WHERE registrationnumber = @regno) = @CanNotifyStatus)   
  BEGIN         
	EXEC dbo.proc_CandidateNotification @CanNotifyStatus,@regno,@sltCandConfirmDate,@finalinterviewdate,@finalinterviewStartTime,@finalinterviewEndTime,@finalinterviewendVenue,@finalInterviewPandingDate,@candidateAfterNoResponseDate,@candUndrInterviewProcessDate;     END      
  End                                                       
      IF NOT EXISTS(SELECT [referenceno],                                   
                           postname                                   
                    FROM   [dbo].[trecruittraker]                                   
                    WHERE  [referenceno] = @candidateno                                   
                           AND postname = @postname)                                   
        BEGIN                                               INSERT INTO [trecruittraker]                                   
                        (referenceno,                                   
                         departmentdivision,                                        postid,                                   
                         postname,                                   
                         locid,                                   
                         headq,                                   
                         candidateid,                                   
                         candidatename,                                   
                         source,                                   
                         startdate,                                   
                         cvselected,                                   
                         roneinterviewdate,                                 
                         roneinterviewernameone,                                   
                         roneinterviewernametwo,                                   
      [roneselect],                                
       [roneinterviewenddate],                                
                         [rtwointerviewdate],                                   
                         [rtwointerviewernameone],                                   
                         [rtwointerviewernametwo],                                
                         [rtwoselect],                                
                      [rtwointerviewenddate],                                
                         [rthreeinterviewdate],                                  
                         [rthreeinterviewernameone],                                  
                         [rthreeinterviewernametwo],                                  
                         [rthreeselect],                                  
       [rthreeinterviewenddate],                                
      [Frinterviewdate],                                  
                         [Frinterviewernameone],                                  
                         [Frinterviewernametwo],                                  
  [frselect],                                  
       [Frinterviewenddate],                                
       [DOO]                                  
       ,[DOJ]                                  
      ,[Empcode]                                  
      ,CompletionStatus                                  
      ,timetaken                                  
      ,[Remarks]                                  
      ,[discrolallow]                                  
         ,[conflictallow]                                  
      --,[iqallow]                                  
      --,[eqallow]                                  
       )                                   
            VALUES      ( @candidateno,                                   
                          @Departmentdivision,                                   
                          @postid,                                   
                  @postname,                                   
                          @locid,                                   
                          @HeadQ,                                   
                          @candidateid,                                   
                          @candidatename,                                   
             @source,                                                            
                          CONVERT(VARCHAR, @STARTDATE, 103),                                   
                          @CVSelected,                                                             
      CONVERT(VARCHAR, @roneinterviewdate, 103),                                   
                     @roneinterviewernameone,                                   
                          @roneinterviewernametwo,                                   
                          @roneselect,                             
        CONVERT(VARCHAR, @roneinterviewenddate, 103),                                  
                          CONVERT(VARCHAR, @rtwointerviewdate, 103),                                   
                          @rtwointerviewernameone,                                   
                          @rtwointerviewernametwo,                                  
        @rtwoselect,                                
   CONVERT(VARCHAR, @rtwointerviewenddate, 103),                                   
        CONVERT(VARCHAR, @rthreeinterviewdate, 103),                                  
                          @rthreeinterviewernameone,                                  
                          @rthreeinterviewernametwo,                                  
        @rthreeselect,                                  
  CONVERT(VARCHAR, @rthreeinterviewenddate, 103),                 
                          @rfinalinterviewdate,                                  
                          @rfinalinterviewernameone,                                  
                         @rfinalinterviewernametwo,                                  
        @firselect,                                          
  @rfinalinterviewenddate,                                
        CONVERT(VARCHAR, @DOO, 103),                                                   
        CONVERT(VARCHAR, @DOJ, 103),                                  
                 @EmployeeCode,                                  
        @CompletionStatus,                                  
        @timetaken,                                  
                 @Remarks,                                  
        @discrollallow,                                   
        @conflictallow                                   
       -- @iqallow,                                   
       -- @eqallow                                   
                                          
        )                                   
     --            if @cancount=2                                  
     --begin                                  
     --update [trecruittraker]                                   
     --set    [discrolallow]=@discrollallow,                                   
     -- conflictallow=@conflictallow,                                   
     -- iqallow=@iqallow,                              
     -- eqallow= @eqallow                                   
     -- WHERE  [referenceno] = @candidateno                                  
     --            end                                  
  --------ADD BY SOUMENDU------------------------                                  
  UPDATE [dbo].[trecruitcanbasicdtls]                                  
  SET  [eqallow]=@eqallow                                   
 WHERE [registrationnumber]=@candidateno                                  
 and ([eqallow] is null or [eqallow]='No')                                  
                                  
 UPDATE [dbo].[trecruitcanbasicdtls]                                  
  SET [iqallow]=@iqallow                                     
 WHERE [registrationnumber]=@candidateno                                  
 and ([iqallow] is null or [iqallow]='No')                                  
                             
 UPDATE [dbo].[trecruitcanbasicdtls]                                  
  SET [bigfiveallow]=@bigfiveallow                                    
 WHERE [registrationnumber]=@candidateno                                  
 and ([bigfiveallow] is null or [bigfiveallow]='No')                            
                                   
 UPDATE [dbo].[trecruitcanbasicdtls]                                  
  SET [firoballow]=@firoballow                                    
 WHERE [registrationnumber]=@candidateno                                  
 and ([firoballow] is null or [firoballow]='No')                                  
                                  
 UPDATE [dbo].[trecruitcanbasicdtls]                                  
 SET [myersbriggsallow]=@myersbriggsallow                                    
 WHERE [registrationnumber]=@candidateno                                  
 and ([myersbriggsallow] is null or [myersbriggsallow]='No')                                  
                                 
 UPDATE [dbo].[trecruitcanbasicdtls]                                  
 SET [rotterlocusofcontrolallow]=@rotterlocusofcontrolallow                                    
 WHERE [registrationnumber]=@candidateno                                  
 and ([rotterlocusofcontrolallow] is null or [rotterlocusofcontrolallow]='No')                                  
                                  
 UPDATE [dbo].[trecruitcanbasicdtls]                                  
 SET [personalitystyleinventoryallow]=@personalitystyleinventoryallow                                    
 WHERE [registrationnumber]=@candidateno                     
 and ([personalitystyleinventoryallow] is null or [personalitystyleinventoryallow]='No')                                  
                               
 UPDATE [dbo].[trecruitcanbasicdtls]                                  
  SET [docsubmissionallow]=@docuploadallow                                    
 WHERE [registrationnumber]=@candidateno                                  
                                   
----------------Saikat Start Put Resubmit Status----------------    
 UPDATE [dbo].[trecruitcanbasicdtls]                                  
  SET [applicationstatus]=@resubmittedStatus,  
  PersonalDtlsResubmitStatus=@PersonalDtlsResubmitStatus,  
  LanguageDtlsResubmitStatus=@FamilyLanguageDtlsResubmitStatus,  
  EducationDtlsResubmitStatus=@EducationDtlsResubmitStatus,  
  EmploymentHistoryDtlsResubmitStatus=@EmploymentHistoryDtlsResubmitStatus,  
  AllFormOpenResubmitStatus=@AllFormOpenResubmitStatus  
 WHERE [registrationnumber]=@candidateno                                  
----------------Saikat Start Put Resubmit Status----------------    
    
    
 -----------END----------------------------------                                  
        END                                   
      ELSE                                   
        BEGIN                                   
            UPDATE [trecruittraker]                                   
SET    headq = @HeadQ,                                   
                   startdate = CONVERT(CHAR(10), @STARTDATE, 126),                                   
                   cvselected = @CVSelected,                                   
       source=@source,                                  
                   roneinterviewdate = CONVERT(CHAR(10), @roneinterviewdate, 126),                                   
                   roneinterviewernameone = @roneinterviewernameone,                                   
                   roneinterviewernametwo = @roneinterviewernametwo,                                   
                   [roneselect] = @roneselect,                                   
       [roneinterviewenddate]=CONVERT(CHAR(10), @roneinterviewenddate, 126),                                
                   [rtwointerviewdate] = CONVERT(CHAR(10), @rtwointerviewdate,126),                                   
                   [rtwointerviewernameone] = @rtwointerviewernameone,                                   
                   [rtwointerviewernametwo] = @rtwointerviewernametwo ,                                 
                   [rtwoselect]=@rtwoselect,                                  
                [rtwointerviewenddate]= CONVERT(CHAR(10), @rtwointerviewenddate,126),                                
                   [rthreeinterviewdate] = CONVERT(VARCHAR, @rthreeinterviewdate, 103),                                  
                   [rthreeinterviewernameone]=@rthreeinterviewernameone,                                  
    [rthreeinterviewernametwo]=@rthreeinterviewernametwo,                                  
                   [rthreeselect]= @rthreeselect,                                  
       [rthreeinterviewenddate] = CONVERT(VARCHAR, @rthreeinterviewenddate, 103),           
                   [Frinterviewdate]=@rfinalinterviewdate,                                  
                   [Frinterviewernameone]=@rfinalinterviewernameone,                                  
                   [Frinterviewernametwo]=@rfinalinterviewernametwo,                                  
                   [frselect]= @firselect,                                
       [Frinterviewenddate] = @rfinalinterviewenddate,                                
       [DOO]=CONVERT(VARCHAR, @DOO, 103),                                  
                   [DOJ]=CONVERT(VARCHAR, @DOJ, 103),                                  
       [Empcode]=@EmployeeCode,                   
       timetaken=@timetaken,                                  
       [Remarks]=@Remarks,                                         
       CompletionStatus=@CompletionStatus,                                  
       [discrolallow]=@discrollallow,                                  
       [conflictallow]=@conflictallow                                  
      -- [iqallow]=@iqallow,                                  
      -- [eqallow]=@eqallow                                  
            WHERE  referenceno = @candidateno                                   
                   AND postname = @postname                                   
                               
     --   if @empcount=0                                  
     --begin                                      
     --update [trecruittraker]                  
     --set    [discrolallow]=@discrollallow,                                   
     -- conflictallow=@conflictallow,                                   
     -- iqallow=@iqallow,                                   
     -- eqallow= @eqallow                                   
     -- WHERE  [referenceno] = @candidateno                                  
     --            end                                  
  --------ADD BY SOUMENDU------------------------                                  
  UPDATE [dbo].[trecruitcanbasicdtls]                                  
  SET  [eqallow]=@eqallow                                   
 WHERE [registrationnumber]=@candidateno                                  
 and ([eqallow] is null or [eqallow]='No')                                  
                                  
 UPDATE [dbo].[trecruitcanbasicdtls]            
  SET [iqallow]=@iqallow                                      
 WHERE [registrationnumber]=@candidateno                                  
 and ([iqallow] is null or [iqallow]='No')                                  
                                  
 UPDATE [dbo].[trecruitcanbasicdtls]                                  
  SET [bigfiveallow]=@bigfiveallow                                    
 WHERE [registrationnumber]=@candidateno                                  
 and ([bigfiveallow] is null or [bigfiveallow]='No')                                  
 UPDATE [dbo].[trecruitcanbasicdtls]                                  
  SET [firoballow]=@firoballow                                    
 WHERE [registrationnumber]=@candidateno                                  
 and ([firoballow] is null or [firoballow]='No')                                  
                                  
 UPDATE [dbo].[trecruitcanbasicdtls]                                  
 SET [myersbriggsallow]=@myersbriggsallow                                    
 WHERE [registrationnumber]=@candidateno                                  
 and ([myersbriggsallow] is null or [myersbriggsallow]='No')                                  
                                  
 UPDATE [dbo].[trecruitcanbasicdtls]               
 SET [rotterlocusofcontrolallow]=@rotterlocusofcontrolallow                                    
 WHERE [registrationnumber]=@candidateno                                  
 and ([rotterlocusofcontrolallow] is null or [rotterlocusofcontrolallow]='No')                                  
                                  
 UPDATE [dbo].[trecruitcanbasicdtls]                                  
 SET [personalitystyleinventoryallow]=@personalitystyleinventoryallow                                    
 WHERE [registrationnumber]=@candidateno                                  
 and ([personalitystyleinventoryallow] is null or [personalitystyleinventoryallow]='No')                                  
                                  
 UPDATE [dbo].[trecruitcanbasicdtls]                                  
  SET [docsubmissionallow]=@docuploadallow                     
 WHERE [registrationnumber]=@candidateno       
     
    
     
----------------Saikat Start Put Resubmit Status----------------    
 UPDATE [dbo].[trecruitcanbasicdtls]                                  
  SET [applicationstatus]=@resubmittedStatus,    
  PersonalDtlsResubmitStatus=@PersonalDtlsResubmitStatus,  
  LanguageDtlsResubmitStatus=@FamilyLanguageDtlsResubmitStatus,  
  EducationDtlsResubmitStatus=@EducationDtlsResubmitStatus,  
  EmploymentHistoryDtlsResubmitStatus=@EmploymentHistoryDtlsResubmitStatus,  
  AllFormOpenResubmitStatus=@AllFormOpenResubmitStatus  
  
 WHERE [registrationnumber]=@candidateno                                  
----------------Saikat Start Put Resubmit Status----------------    
 -----------END----------------------------------                                  
                                  
                                  
        END                                   
                                  
      IF NOT EXISTS (SELECT [candidateid],                                   
                            postid,                                   
                            locid                                   
                     FROM   [trecruittrakeruploadfileone]                                   
                     WHERE  [candidateid] = @candidateid                                   
             AND postid = @postid                                   
                            AND locid = @locid)                                   
        BEGIN                                   
            INSERT INTO [trecruittrakeruploadfileone]                                   
                        ([candidateid],                                   
                         postid,                                   
                         locid,                                   
                         [fname],                                   
                         [fcontenttype],                                   
                         [fresumefile],                                   
                         [sname],                                   
                         [scontenttype],                                   
                         [sresumefile])                                   
            VALUES      ( @candidateid,                                   
                          @postid,                                   
       @locid,                                   
                          @frintervieweronefilename,                                   
                          @frintervieweroneContentType,                                   
                          @frintervieweronerfile,                                   
 @frinterviewertwofilename,                                   
                          @frinterviewertwoContentType,                                   
                          @frinterviewertworfile )                                   
        END                                   
      ELSE IF @frintervieweroneContentType IS NOT NULL                                   
          AND @frinterviewertwoContentType IS NOT NULL                                   
        BEGIN                                   
            UPDATE [trecruittrakeruploadfileone]                                   
            SET    [fname] = @frintervieweronefilename,                                   
                   [fcontenttype] = @frintervieweroneContentType,                    
                   [fresumefile] = @frintervieweronerfile,                                   
                   [sname] = @frinterviewertwofilename,                                   
                   [scontenttype] = @frinterviewertwoContentType,                                   
                   [sresumefile] = @frinterviewertworfile                                   
            WHERE  candidateid = @candidateid                                   
                   AND [postid] = @postid                                   
                   AND [locid] = @locid               
        END                                   
      ELSE IF @frintervieweroneContentType IS NOT NULL                                   
        BEGIN                                   
            UPDATE [trecruittrakeruploadfileone]                                   
            SET    [fname] = @frintervieweronefilename,                                   
                   [fcontenttype] = @frintervieweroneContentType,                                   
                   [fresumefile] = @frintervieweronerfile                                   
            WHERE  candidateid = @candidateid                                   
                   AND [postid] = @postid                                   
                   AND [locid] = @locid                                   
        END                                   
      ELSE IF @frinterviewertwoContentType IS NOT NULL                                   
        BEGIN                                   
UPDATE [trecruittrakeruploadfileone]                                   
            SET    [sname] = @frinterviewertwofilename,                                   
                   [scontenttype] = @frinterviewertwoContentType,                                   
                   [sresumefile] = @frinterviewertworfile                                   
       WHERE  candidateid = @candidateid                                   
                   AND [postid] = @postid                                   
 AND [locid] = @locid                                   
        END                                   
  END                                   
                                  
IF NOT EXISTS (SELECT [candidateid],                                   
                      postid,                                   
                      locid                                   
               FROM   [trecruittrakeruploadfiletwo]                                   
             WHERE  [candidateid] = @candidateid                                   
                    AND postid = @postid                                   
                      AND locid = @locid)                                   
  BEGIN                                   
      INSERT INTO [trecruittrakeruploadfiletwo]                                   
                  ([candidateid],                                   
                   postid,                                   
                   locid,                                   
                   [fname],                                   
                   [fcontenttype],                                   
                   [fresumefile],                                   
                   [sname],                                   
                   [scontenttype],                                   
                   [sresumefile])              
      VALUES      ( @candidateid,                                   
                    @postid,                                   
                    @locid,                                   
                    @srintervieweronefilename,                                   
                    @srintervieweroneContentType,                                   
                    @srintervieweronerfile,                                   
                    @srinterviewertwofilename,                                   
                    @srinterviewertwoContentType,                                   
                    @srinterviewertworfile )                                   
  END                                   
ELSE IF @srintervieweroneContentType IS NOT NULL                                   
    AND @srinterviewertwoContentType IS NOT NULL                                   
  BEGIN                                   
      UPDATE [trecruittrakeruploadfiletwo]                                   
      SET    [fname] = @srintervieweronefilename,                                   
             [fcontenttype] = @srintervieweroneContentType,                                   
             [fresumefile] = @srintervieweronerfile,                                   
       [sname] = @srinterviewertwofilename,                                   
             [scontenttype] = @srinterviewertwoContentType,                                   
             [sresumefile] = @srinterviewertworfile                                   
      WHERE  candidateid = @candidateid                                   
             AND [postid] = @postid                                   
             AND [locid] = @locid                                   
  END                                   
ELSE IF @srintervieweroneContentType IS NOT NULL                                
  BEGIN                                   
      UPDATE [trecruittrakeruploadfiletwo]                                   
      SET    [fname] = @srintervieweronefilename,                                   
             [fcontenttype] = @srintervieweroneContentType,                                   
             [fresumefile] = @srintervieweronerfile                                   
      WHERE  candidateid = @candidateid                                   
             AND [postid] = @postid                                   
             AND [locid] = @locid                                   
  END                                   
ELSE IF @srinterviewertwoContentType IS NOT NULL                                   
  BEGIN                              
      UPDATE [trecruittrakeruploadfiletwo]                                   
      SET    [sname] = @srinterviewertwofilename,                                   
             [scontenttype] = @srinterviewertwoContentType,                                   
             [sresumefile] = @srinterviewertworfile                                   
      WHERE  candidateid = @candidateid                                   
             AND [postid] = @postid                                   
             AND [locid] = @locid                                   
                                  
END                                   
IF NOT EXISTS (SELECT [candidateid],                                   
                      postid,                                   
                   locid                                   
               FROM   [trecruittrakeruploadfilethree]                                   
               WHERE  [candidateid] = @candidateid                                   
   AND postid = @postid                                   
                      AND locid = @locid)                                   
  BEGIN                                   
      INSERT INTO [trecruittrakeruploadfilethree]                                   
                  ([candidateid],                                   
            postid,                                   
                   locid,                                   
                   [fname],                                   
                   [fcontenttype],                                   
                   [fresumefile],                      
                   [sname],                                   
                   [scontenttype],                                   
                   [sresumefile])                                   
      VALUES      ( @candidateid,                                   
                    @postid,                  
                    @locid,                                   
                    @trintervieweronefilename,                                   
                    @trintervieweroneContentType,                                   
                    @trintervieweronerfile,                                   
                    @trinterviewertwofilename,                                   
               @trinterviewertwoContentType,                                   
                    @trinterviewertworfile )                                   
  END                                   
ELSE IF @trintervieweroneContentType IS NOT NULL                                   
   AND @trinterviewertwoContentType IS NOT NULL                              
  BEGIN                                   
      UPDATE [trecruittrakeruploadfilethree]                                   
      SET    [fname] = @trintervieweronefilename,                                   
             [fcontenttype] = @trintervieweroneContentType,                                   
             [fresumefile] = @trintervieweronerfile,                                   
             [sname] = @trinterviewertwofilename,                                   
             [scontenttype] = @trinterviewertwoContentType,                                   
             [sresumefile] = @trinterviewertworfile                                   
      WHERE  candidateid = @candidateid                                   
             AND [postid] = @postid                                   
             AND [locid] = @locid                                   
  END                                   
ELSE IF @trintervieweroneContentType IS NOT NULL                                   
  BEGIN                                   
      UPDATE [trecruittrakeruploadfilethree]                                   
      SET    [fname] = @trintervieweronefilename,                                   
             [fcontenttype] = @trintervieweroneContentType,                                   
             [fresumefile] = @trintervieweronerfile                                   
      WHERE  candidateid = @candidateid                                   
             AND [postid] = @postid                                   
             AND [locid] = @locid                                   
  END                                   
ELSE IF @trinterviewertwoContentType IS NOT NULL                                   
  BEGIN                                   
      UPDATE [trecruittrakeruploadfilethree]                                   
      SET    [sname] = @trinterviewertwofilename,                                   
             [scontenttype] = @trinterviewertwoContentType,                                   
             [sresumefile] = @trinterviewertworfile                                   
      WHERE  candidateid = @candidateid                                   
             AND [postid] = @postid                                   
             AND [locid] = @locid                        
                                  
END                                   
IF NOT EXISTS (SELECT [candidateid],                                   
                      postid,                                   
                      locid                                   
               FROM   [trecruittrakeruploadfilefinal]                                   
               WHERE  [candidateid] = @candidateid                                   
                      AND postid = @postid                                   
                      AND locid = @locid)                                   
  BEGIN                                   
      INSERT INTO [trecruittrakeruploadfilefinal]                                   
                  ([candidateid],                                   
                   postid,                                   
               locid,                                   
                   [fname],                     
                   [fcontenttype],                                   
                   [fresumefile],                                   
                   [sname],                                   
                   [scontenttype],                                   
                   [sresumefile])                                   
      VALUES      ( @candidateid,                                   
                    @postid,                                   
                    @locid,                                   
                    @firintervieweronefilename,                                   
                    @firintervieweroneContentType,                                   
              @firintervieweronerfile,                                   
                    @firinterviewertwofilename,                                   
                    @firinterviewertwoContentType,                                   
                    @firinterviewertworfile )                                   
  END                             
ELSE IF @firintervieweroneContentType IS NOT NULL                                   
   AND @firinterviewertwoContentType IS NOT NULL                                   
  BEGIN                                   
      UPDATE [trecruittrakeruploadfilefinal]                                   
      SET    [fname] = @firintervieweronefilename,                                   
             [fcontenttype] = @firintervieweroneContentType,                                   
             [fresumefile] = @firintervieweronerfile,                                   
             [sname] = @firinterviewertwofilename,                                   
             [scontenttype] = @firinterviewertwoContentType,                                   
             [sresumefile] = @firinterviewertworfile                                   
      WHERE  candidateid = @candidateid                                   
             AND [postid] = @postid                                   
             AND [locid] = @locid                                   
  END                                   
ELSE IF @firintervieweroneContentType IS NOT NULL                                   
  BEGIN                                       UPDATE [trecruittrakeruploadfilefinal]                                   
      SET    [fname] = @firintervieweronefilename,                                   
             [fcontenttype] = @firintervieweroneContentType,                                   
             [fresumefile] = @firintervieweronerfile                                   
      WHERE  candidateid = @candidateid                                   
             AND [postid] = @postid                                   
             AND [locid] = @locid                                   
  END                                   
ELSE IF @firinterviewertwoContentType IS NOT NULL                                   
  BEGIN                                   
      UPDATE [trecruittrakeruploadfilefinal]                                   
    SET    [sname] = @firinterviewertwofilename,                                   
             [scontenttype] = @firinterviewertwoContentType,                                   
             [sresumefile] = @firinterviewertworfile                                   
      WHERE  candidateid = @candidateid                                   
             AND [postid] = @postid                                   
             AND [locid] = @locid                                   
                              
--proc_CandidateNotification 'Under interview process','DUMMY USER TEST','Candidate006135'                              
                              
                            
   --   select @CanNotifyStatus                            
END     
  
GO





/* ============================================================================
   7. ATS - configuration, scoring, score details, bulk resume ATS, JD matching
   TABLE DEFINITIONS
============================================================================ */

/****** Object:  Table [dbo].[ATS_DTLS_RATING]    Script Date: 15-08-2026 10:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ATS_DTLS_RATING](
	[ATS_DTLS_RATING_ID] [int] IDENTITY(1,1) NOT NULL,
	[ATS_HEAD_RATING_ID] [int] NOT NULL,
	[ATS_RATING_MASTER_ID] [int] NOT NULL,
	[RATING_MARKS] [varchar](20) NOT NULL,
	[DESCRIPTION] [nvarchar](max) NULL,
	[ACTIVEFLAG] [int] NOT NULL,
 CONSTRAINT [PK_ATS_DTLS_RATING] PRIMARY KEY CLUSTERED 
(
	[ATS_DTLS_RATING_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO



/****** Object:  Table [dbo].[ATS_HEAD_RATING]    Script Date: 15-08-2026 10:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ATS_HEAD_RATING](
	[ATS_HEAD_RATING_ID] [int] IDENTITY(1,1) NOT NULL,
	[ATS_HEAD_RATING_NAME] [varchar](200) NOT NULL,
	[TOTAL_RATING_MARKS] [decimal](18, 2) NOT NULL,
	[ACTIVEFLAG] [int] NOT NULL,
 CONSTRAINT [PK_ATS_HEAD_RATING] PRIMARY KEY CLUSTERED 
(
	[ATS_HEAD_RATING_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO



/****** Object:  Table [dbo].[ATS_RATING_MASTER]    Script Date: 15-08-2026 10:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ATS_RATING_MASTER](
	[ATS_RATING_MASTER_ID] [int] IDENTITY(1,1) NOT NULL,
	[ATS_TYPE_ID] [int] NOT NULL,
	[DESCRIPTION] [varchar](50) NOT NULL,
	[DETAILS_DESCRIPTION] [nvarchar](max) NULL,
	[ACTIVEFLAG] [int] NOT NULL,
 CONSTRAINT [PK_ATS_RATING_MASTER] PRIMARY KEY CLUSTERED 
(
	[ATS_RATING_MASTER_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO



/****** Object:  Table [dbo].[ATS_TYPE]    Script Date: 15-08-2026 10:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ATS_TYPE](
	[ATS_TYPE_ID] [int] NOT NULL,
	[ATS_TYPE_NAME] [varchar](50) NOT NULL
) ON [PRIMARY]
GO



/****** Object:  Table [dbo].[BulkResumeAtsScoreLog]    Script Date: 15-08-2026 10:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BulkResumeAtsScoreLog](
	[BulkResumeAtsScoreLogID] [bigint] IDENTITY(1,1) NOT NULL,
	[POST_ID] [int] NOT NULL,
	[CV_NAME] [nvarchar](500) NULL,
	[SAVED_CV_NAME] [nvarchar](500) NULL,
	[RESUME_FILE_LOCATION] [nvarchar](1000) NULL,
	[IMAGE_FILE_LOCATION] [nvarchar](1000) NULL,
	[FILE_HASH] [varchar](64) NULL,
	[CANDIDATE_NAME] [nvarchar](500) NULL,
	[MAIL_ID] [nvarchar](500) NULL,
	[PHONE_NUMBER] [nvarchar](50) NULL,
	[COMPANY_ID] [int] NULL,
	[DEPARTMENT_ID] [int] NULL,
	[ATS_HEAD_RATING_ID] [int] NULL,
	[GENERATED_CANDIDATE_ID] [bigint] NULL,
	[EXAM_OBTAINED_SCORE] [decimal](18, 2) NULL,
	[EXAM_IS_SHORTLISTED] [bit] NULL,
	[EXAM_RESULT_DATE] [datetime] NULL,
	[ATS_STATUS] [nvarchar](100) NULL,
	[IS_SHORTLISTED] [bit] NOT NULL,
	[IS_DUPLICATE] [bit] NOT NULL,
	[DUPLICATE_OF_LOG_ID] [bigint] NULL,
	[FULL_JSON] [nvarchar](max) NULL,
	[CANDIDATE_JSON] [nvarchar](max) NULL,
	[CREATED_DATE] [datetime] NOT NULL,
	[ImageName] [nvarchar](500) NULL,
 CONSTRAINT [PK_BulkResumeAtsScoreLog] PRIMARY KEY CLUSTERED 
(
	[BulkResumeAtsScoreLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO



/****** Object:  Table [dbo].[DTLS_ATS_SCORE]    Script Date: 15-08-2026 10:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DTLS_ATS_SCORE](
	[DTLS_ATS_SCORE] [int] IDENTITY(1,1) NOT NULL,
	[ATS_SCORE_ID] [bigint] NOT NULL,
	[CRITERIA_ID] [bigint] NULL,
	[CRITERIA] [varchar](250) NULL,
	[TOTAL_SCORE] [decimal](18, 2) NULL,
	[OBTAIN_SCORE] [decimal](18, 2) NULL,
	[NOTES] [nvarchar](max) NULL,
 CONSTRAINT [PK__DTLS_ATS__7309F4DE5F780634] PRIMARY KEY CLUSTERED 
(
	[DTLS_ATS_SCORE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO



/****** Object:  Table [dbo].[HEAD_ATS_SCORE]    Script Date: 15-08-2026 10:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HEAD_ATS_SCORE](
	[ATS_SCORE_ID] [bigint] IDENTITY(1,1) NOT NULL,
	[CANDIDATE_ID] [bigint] NULL,
	[ACTUAL_POST_ID] [bigint] NULL,
	[LOCATION_ID] [bigint] NULL,
	[COMPANY_ID] [bigint] NULL,
	[DEPARTMENT_ID] [bigint] NULL,
	[TOTAL_SCORE] [decimal](18, 2) NULL,
	[OBTAIN_MARKS] [decimal](18, 2) NULL,
	[REMARKS] [varchar](max) NULL,
	[STATUS] [varchar](20) NULL,
	[ExamMarks] [decimal](10, 2) NULL,
	[ExamStatus] [varchar](50) NULL,
 CONSTRAINT [PK__HEAD_ATS__3B17D4F0E23903AF] PRIMARY KEY CLUSTERED 
(
	[ATS_SCORE_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO



/****** Object:  Table [dbo].[TempCandidateDetails]    Script Date: 15-08-2026 10:05:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TempCandidateDetails](
	[CandidateID] [bigint] NULL,
	[CandidateFirstName] [nvarchar](max) NULL,
	[CandidateMiddleName] [nvarchar](max) NULL,
	[CandidateLastName] [nvarchar](max) NULL,
	[DateOfBirth] [nvarchar](max) NULL,
	[Address] [nvarchar](max) NULL,
	[PinCode] [nvarchar](max) NULL,
	[CityOrVillage] [nvarchar](max) NULL,
	[PostOffice] [nvarchar](max) NULL,
	[Country] [nvarchar](max) NULL,
	[State] [nvarchar](max) NULL,
	[District] [nvarchar](max) NULL,
	[Email] [nvarchar](max) NULL,
	[Mobile] [nvarchar](max) NULL,
	[AnyProject] [nvarchar](max) NULL,
	[NumberOfCompanyChanges] [nvarchar](max) NULL,
	[ResumeContentType] [nvarchar](max) NULL,
	[ResumeFileName] [nvarchar](max) NULL,
	[Resumefile] [varbinary](max) NULL,
	[QualificationJison] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO




/* ----------------------------------------------------------------------------
   7. ATS - configuration, scoring, score details, bulk resume ATS, JD matching
   STORED PROCEDURES
---------------------------------------------------------------------------- */

/* ---- PRIMARY / NON-TEMP PROCEDURES ---- */
