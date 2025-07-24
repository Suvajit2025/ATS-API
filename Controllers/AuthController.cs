using ATS.API.Models;
using CommonUtility.Interface;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using System.Data;

namespace ATS.API.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly IDataService _dataService;
        private readonly IConfiguration _configuration;
        private readonly string _conn;
        public AuthController(UserManager<ApplicationUser> userManager,IDataService dataService,IConfiguration configuration)
        {
            _userManager = userManager;
            _dataService = dataService;
            _configuration = configuration;
            _conn = configuration.GetConnectionString("DefaultConnection");

        }

        [HttpPost("SignUp")]
        public async Task<IActionResult> SignUp([FromBody] SignUp signUp)
        {
            try
            {
                var existingUser = await _userManager.FindByNameAsync(signUp.username);

                if (existingUser != null)
                {
                    // ✅ Username exists — check if password matches
                    var isPasswordMatch = await _userManager.CheckPasswordAsync(existingUser, signUp.password);

                    if (isPasswordMatch)
                    {
                        // ✅ Username and password match — do nothing
                        return Ok(new { message = "User already exists with matching password. No changes made.", userId = existingUser.Id });
                    }
                    else
                    {
                        // ✅ Username same but password different — update password
                        var resetToken = await _userManager.GeneratePasswordResetTokenAsync(existingUser);
                        var result = await _userManager.ResetPasswordAsync(existingUser, resetToken, signUp.password);

                        if (!result.Succeeded)
                        {
                            var errors = result.Errors.Select(e => e.Description).ToList();
                            return BadRequest(new { message = "Password update failed", errors });
                        }

                        return Ok(new { message = "Password updated successfully", userId = existingUser.Id });
                    }
                }

                // ✅ Create new user
                Guid candidateCodeGuid = Guid.Empty;
                if (signUp.CandidateCode.HasValue && signUp.CandidateCode.Value != Guid.Empty)
                {
                    candidateCodeGuid = signUp.CandidateCode.Value;
                }
                else
                {
                    candidateCodeGuid = Guid.NewGuid(); // Generate new if not present
                }
                if (signUp.TenantKey == null)
                { 
                    var parameters=new Dictionary<string, object>() { 
                        {"@IDCompany", signUp.id },
                        {"@username",signUp.username},
                    };
                    DataSet ds = await _dataService.GetAllDatasetAsync("Get_TenantDetails", parameters, _conn);

                    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        var tenantRow = ds.Tables[0].Rows[0];

                        signUp.TenantId = Convert.ToInt32(tenantRow["TenantId"]);
                        signUp.TenantKey = Guid.Parse(tenantRow["TenantKey"].ToString());

                        // Check if second table and at least one row exist before accessing
                        if (ds.Tables.Count > 1 && ds.Tables[1].Rows.Count > 0)
                        {
                            var candidateRow = ds.Tables[1].Rows[0];
                            signUp.CandidateId = Convert.ToInt64(candidateRow["CandidateId"]);
                        }
                    }
                    else
                    {
                        // Handle not found
                        Console.WriteLine("No tenant details found for given IDCompany.");
                    }

                }
                
                if (string.IsNullOrWhiteSpace(signUp.username) ||
                    string.IsNullOrWhiteSpace(signUp.password) ||
                    signUp.TenantKey == null ||
                    signUp.TenantId <= 0 ||
                    signUp.CandidateId == null || signUp.CandidateId <= 0 )
                {
                    return BadRequest("All fields are required and must be valid.");
                }
                var newUser = new ApplicationUser
                {
                    UserName = signUp.username,
                    Email = signUp.username,
                    TenantId = Convert.ToInt32(signUp.TenantId),
                    TenantCode = signUp.TenantKey.ToString().ToUpper(),
                    CandidateId = Convert.ToInt64(signUp.CandidateId),
                    CandidateCode = candidateCodeGuid
                };

                var createResult = await _userManager.CreateAsync(newUser, signUp.password);

                if (!createResult.Succeeded)
                {
                    var errors = createResult.Errors.Select(e => e.Description).ToList();
                    return BadRequest(new { message = "User creation failed", errors });
                }

                return Ok(new { message = "User created successfully", userId = newUser.Id });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = ex.Message });
            }
        }

    }
}
