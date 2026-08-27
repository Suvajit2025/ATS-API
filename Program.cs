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

// Explicitly load configuration from appsettings.json
builder.Configuration
    .SetBasePath(Directory.GetCurrentDirectory())
    .AddJsonFile("appsettings.json", optional: true, reloadOnChange: true)
    .AddEnvironmentVariables();
 // ------------------------
// Controllers
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddHttpContextAccessor();
builder.Services.AddHttpClient();

// Read concurrency setting
int maxConcurrency = builder.Configuration.GetValue<int>("MaxConcurrency");
if (maxConcurrency <= 0)
{
    maxConcurrency = 3;
}

// ATS Services
builder.Services.AddScoped<IATSHelper, ATSHelperRepo>();
builder.Services.AddScoped<BulkResumeService>();

builder.Services.AddScoped<ICandidateProcessor>(provider =>
{
    return new CandidateProcessor(
        provider.GetRequiredService<IATSHelper>(),
        maxConcurrency
    );
});
builder.Services.AddScoped<LmsExamLinkService>();
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
builder.Services.AddScoped<IETimeTrackRepository, ETimeTrackRepository>();
builder.Services.AddScoped<MailService>();

// File Migration Service, FTP Storage & Background Job (every 30 mins)
builder.Services.AddScoped<FtpStorageService>();
builder.Services.AddScoped<FileMigrationService>();
builder.Services.AddHostedService<FileMigrationBackgroundService>();

// Attendance Hosted Services
builder.Services.AddHostedService<ETimeTrackCollectorService>();
builder.Services.AddHostedService<RawPunchFallbackService>();
builder.Services.AddHostedService<MidnightAttendanceService>();

// Bind Attendance Job Settings
builder.Services.Configure<AttendanceJobSettings>(
    builder.Configuration.GetSection("AttendanceJobs")
);

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
        policy.SetIsOriginAllowed(origin =>
              {
                  if (string.IsNullOrWhiteSpace(origin))
                      return false;

                  var host = new Uri(origin).Host;
                  return host.Equals("localhost", StringComparison.OrdinalIgnoreCase)
                      || host.Equals("127.0.0.1", StringComparison.OrdinalIgnoreCase)
                      || host.Equals("recruitment.mendine.co.in", StringComparison.OrdinalIgnoreCase)
                      || host.Equals("recruitmentsaas.mendine.co.in", StringComparison.OrdinalIgnoreCase);
              })
              .AllowAnyHeader()
              .AllowAnyMethod();
    });
});

var app = builder.Build();

// Support IIS Virtual Application PathBase /ATS
app.Use(async (context, next) =>
{
    if (context.Request.Path.StartsWithSegments("/ATS", StringComparison.OrdinalIgnoreCase, out var remainingPath))
    {
        context.Request.PathBase = "/ATS";
        context.Request.Path = remainingPath;
    }
    await next();
});

// Enable Swagger in all environments (Development & Published Production under IIS /ATS)
app.UseSwagger(c =>
{
    c.RouteTemplate = "swagger/{documentName}/swagger.json";
});

app.UseSwaggerUI(c =>
{
    c.SwaggerEndpoint("v1/swagger.json", "ATS API v1");
    c.SwaggerEndpoint("/ATS/swagger/v1/swagger.json", "ATS API v1 (/ATS)");
    c.SwaggerEndpoint("/swagger/v1/swagger.json", "ATS API v1 (Root)");
    c.RoutePrefix = "swagger";
});

app.UseSwaggerUI(c =>
{
    c.SwaggerEndpoint("swagger/v1/swagger.json", "ATS API v1");
    c.SwaggerEndpoint("/ATS/swagger/v1/swagger.json", "ATS API v1 (/ATS)");
    c.RoutePrefix = string.Empty; // Serves Swagger UI directly at https://atsapi.mendine.co.in/ATS
});

// Middleware
app.UseCors("AllowFrontend");

app.UseHttpsRedirection();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.Run();
