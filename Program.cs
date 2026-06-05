using ATS.API.Interface;
using ATS.API.Models;
using ATS.API.Repository;
using ATS.API.Services;
using ATS.API.Services.MailService;
using CommonUtility.DataAccess;
using CommonUtility.Interface;
using CommonUtility.Repository; 
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore; 
 
var builder = WebApplication.CreateBuilder(args);
 // ------------------------
// Controllers
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddHttpContextAccessor();
builder.Services.AddHttpClient();

// Read concurrency setting
int maxConcurrency = builder.Configuration.GetValue<int>("MaxConcurrency");

// ATS Services
builder.Services.AddScoped<IATSHelper, ATSHelperRepo>();

builder.Services.AddScoped<ICandidateProcessor>(provider =>
{
    return new CandidateProcessor(
        provider.GetRequiredService<IATSHelper>(),
        maxConcurrency
    );
});

// DATABASE CONNECTIONS
var dbConnRecruit = builder.Configuration.GetConnectionString("DBConnRecruitment");
var dbConnRecruitDemo = builder.Configuration.GetConnectionString("DBConnRecruitmentDemo");
var dbConnEssP = builder.Configuration.GetConnectionString("DBConnEssp");
var dbConnSaaSEssP = builder.Configuration.GetConnectionString("DBConnSaaSEssP");

// Register ONE ADO + DataService
builder.Services.AddScoped<AdoDataAccess>(provider =>
{
    return new AdoDataAccess(dbConnRecruit);
});

builder.Services.AddScoped<IDataService>(provider =>
{
    var ado = provider.GetRequiredService<AdoDataAccess>();
    return new DataServiceRepository(ado, dbConnRecruit);
});

// Identity DB
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");

builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlServer(connectionString));

// Identity
builder.Services.AddIdentity<ApplicationUser, IdentityRole>(options =>
{
    options.Password.RequireDigit = false;
    options.Password.RequireLowercase = false;
    options.Password.RequireNonAlphanumeric = false;
    options.Password.RequireUppercase = false;
    options.Password.RequiredLength = 4;
    options.Password.RequiredUniqueChars = 0;
})
.AddEntityFrameworkStores<ApplicationDbContext>()
.AddDefaultTokenProviders();

// Repository
//builder.Services.AddScoped<IETimeTrackRepository, ETimeTrackRepository>();
builder.Services.AddScoped<MailService>();

// Hosted Services
//builder.Services.AddHostedService<ETimeTrackCollectorService>();
//builder.Services.AddHostedService<RawPunchFallbackService>();
//builder.Services.AddHostedService<MidnightAttendanceService>();

// Bind Attendance Job Settings
//builder.Services.Configure<AttendanceJobSettings>(
//    builder.Configuration.GetSection("AttendanceJobs")
//);

// Common Services
builder.Services.AddScoped<ICommonService, CommonServiceRepository>();
builder.Services.AddScoped<IEncryptDecrypt, EncryptDecryptRepository>();
builder.Services.AddScoped<IConversion, ConversionRepository>();

// Background Queue
builder.Services.AddSingleton<IBackgroundTaskQueue>(provider =>
{
    return new BackgroundTaskQueue(maxConcurrency);
});

builder.Services.AddHostedService<BackgroundTaskProcessorService>();

// CORS
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowFrontend", policy =>
    {
        policy.WithOrigins("https://recruitment.mendine.co.in")
              .AllowAnyHeader()
              .AllowAnyMethod();
    });
});

var app = builder.Build();
// Swagger
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// Middleware
app.UseCors("AllowFrontend");

app.UseHttpsRedirection();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.Run();