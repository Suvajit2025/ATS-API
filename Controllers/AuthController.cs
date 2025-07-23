using ATS.API.Models;
using CommonUtility.Interface;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

namespace ATS.API.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly UserManager<ApplicationUser> _userManager;

        public AuthController(UserManager<ApplicationUser> userManager)
        {
            _userManager = userManager;
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
                if (!string.IsNullOrWhiteSpace(signUp.CandidateCode?.ToString()) &&
                    Guid.TryParse(signUp.CandidateCode.ToString(), out Guid parsedCandidateCode))
                {
                    candidateCodeGuid = parsedCandidateCode;
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
