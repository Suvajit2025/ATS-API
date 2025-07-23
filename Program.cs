using ATS.API.Interface;
using ATS.API.Models;
using ATS.API.Repository;
using ATS.API.Services;
using CommonUtility.DataAccess;
using CommonUtility.Interface;
using CommonUtility.Repository;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// ✅ Register IHttpContextAccessor
builder.Services.AddHttpContextAccessor();
 
builder.Services.AddHttpClient();
// Read the MaxConcurrency value from appsettings.json
int maxConcurrency = builder.Configuration.GetValue<int>("MaxConcurrency");
builder.Services.AddScoped<ICandidateProcessor>(provider =>
{
    return new CandidateProcessor(provider.GetRequiredService<IATSHelper>(), maxConcurrency);
});
// ATS-specific services
builder.Services.AddScoped<IATSHelper, ATSHelperRepo>();

// Recruitment DB connection
var dbConnRecruit = builder.Configuration.GetConnectionString("DBConnRecruitment");

// RecruitmentDemo DB connection
var dbConnRecruitDemo = builder.Configuration.GetConnectionString("DBConnRecruitmentDemo");

// ESSP DB connection
var dbConnEssP = builder.Configuration.GetConnectionString("DBConnEssp");

// Register AdoDataAccess for Recruitment
builder.Services.AddScoped<AdoDataAccess>(provider => new AdoDataAccess(dbConnRecruit));

// Register AdoDataAccess for RecruitmentDemo
builder.Services.AddScoped<AdoDataAccess>(provider => new AdoDataAccess(dbConnRecruitDemo));

// Register AdoDataAccess for RecruitmentDemo
builder.Services.AddScoped<AdoDataAccess>(provider => new AdoDataAccess(dbConnEssP));

// Register IDataService for Recruitment
builder.Services.AddScoped<IDataService>(provider =>
{
    var adoDataAccess = new AdoDataAccess(dbConnRecruit);
    return new DataServiceRepository(adoDataAccess, dbConnRecruit);
});

// Register IDataService for RecruitmentDemo
builder.Services.AddScoped<IDataService>(provider =>
{
    var adoDataAccessDemo = new AdoDataAccess(dbConnRecruitDemo);
    return new DataServiceRepository(adoDataAccessDemo, dbConnRecruitDemo);
});

// Register IDataService for Essp
builder.Services.AddScoped<IDataService>(provider =>
{
    var adoDataAccessEssP = new AdoDataAccess(dbConnEssP);
    return new DataServiceRepository(adoDataAccessEssP, dbConnEssP);
});
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");

builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlServer(connectionString));



builder.Services.AddIdentity<ApplicationUser, IdentityRole>(options =>
{
    options.Password.RequireDigit = false;
    options.Password.RequireLowercase = false;
    options.Password.RequireNonAlphanumeric = false; // 👈 This disables the special character requirement
    options.Password.RequireUppercase = false;
    options.Password.RequiredLength = 4;
    options.Password.RequiredUniqueChars = 0;
})
.AddEntityFrameworkStores<ApplicationDbContext>()
.AddDefaultTokenProviders();


// Common services
builder.Services.AddScoped<ICommonService, CommonServiceRepository>();
builder.Services.AddScoped<IEncryptDecrypt, EncryptDecryptRepository>();
builder.Services.AddScoped<IConversion, ConversionRepository>();

// Background Task Queue and Processor
//builder.Services.AddSingleton<IBackgroundTaskQueue, BackgroundTaskQueue>();  // Register BackgroundTaskQueue

builder.Services.AddSingleton<IBackgroundTaskQueue>(provider =>
{
    return new BackgroundTaskQueue(maxConcurrency);
});

builder.Services.AddHostedService<BackgroundTaskProcessorService>();        // Register BackgroundTaskProcessorService

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowFrontend", policy =>
    {
        policy.WithOrigins("https://recruitment.mendine.co.in/")  
              .AllowAnyHeader()
              .AllowAnyMethod();
    });
});


var app = builder.Build();

// Configure the HTTP request pipeline
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors("AllowFrontend");

app.UseHttpsRedirection();

app.UseAuthentication();

// Use Authorization Middleware
app.UseAuthorization();

// Map Controllers to handle HTTP requests
app.MapControllers();

// Run the application
app.Run();
