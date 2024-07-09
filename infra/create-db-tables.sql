CREATE SCHEMA [covid_reporting]
GO

/****** Object:  Table [covid_reporting].[cases_and_deaths]  ******/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [covid_reporting].[cases_and_deaths](
	[country] [varchar](100) NULL,
	[country_code_2_digit] [varchar](2) NULL,
	[country_code_3_digit] [varchar](3) NULL,
	[population] [bigint] NULL,
	[cases_count] [bigint] NULL,
	[deaths_count] [bigint] NULL,
	[reported_date] [date] NULL,
	[source] [varchar](500) NULL
) ON [PRIMARY]
GO

/****** Object:  Table [covid_reporting].[hospital_admissions_daily]  ******/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [covid_reporting].[hospital_admissions_daily](
	[country] [varchar](100) NULL,
	[country_code_2_digit] [varchar](2) NULL,
	[country_code_3_digit] [varchar](3) NULL,
	[population] [bigint] NULL,
	[reported_date] [date] NULL,
	[hospital_occupancy_count] [bigint] NULL,
	[icu_occupancy_count] [bigint] NULL,
	[source] [varchar](500) NULL
) ON [PRIMARY]
GO

/****** Object:  Table [covid_reporting].[testing]  ******/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [covid_reporting].[testing](
	[country] [varchar](100) NULL,
	[country_code_2_digit] [varchar](2) NULL,
	[country_code_3_digit] [varchar](3) NULL,
	[year_week] [varchar](8) NULL,
	[week_start_date] [date] NULL,
	[week_end_date] [date] NULL,
	[new_cases] [bigint] NULL,
	[tests_done] [bigint] NULL,
	[population] [bigint] NULL,
	[testing_data_source] [varchar](500) NULL
) ON [PRIMARY]
GO
