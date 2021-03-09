using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;

namespace b4backend.Controllers
{
    [Route("api/[controller]/[action]")]
    public class AccountController : Controller
    {
        private readonly SignInManager<IdentityUser> _signInManager;
        private readonly UserManager<IdentityUser> _userManager;
        private readonly RoleManager<IdentityRole> _roleManager;
        private readonly IConfiguration _configuration;

        public AccountController(
            UserManager<IdentityUser> userManager,
            RoleManager<IdentityRole> roleManager,
            SignInManager<IdentityUser> signInManager,
            IConfiguration configuration
            )
        {
            _userManager = userManager;
            _signInManager = signInManager;
            _configuration = configuration;
            _roleManager = roleManager;
        }

        [HttpPost]
        public async Task<object> Login([FromBody] LoginDto model)
        {
            var result = await _signInManager.PasswordSignInAsync(model.Email, model.Password, false, false);

            if (result.Succeeded)
            {
                var appUser = _userManager.Users.SingleOrDefault(r => r.Email == model.Email);
                var userRole = await _userManager.GetRolesAsync(appUser);
                return new { token = GenerateJwtToken(model.Email, appUser, userRole) };
            }
            else
            {
                return StatusCode(401, new { mensaje = "Error, usuario y clave invalidos" });
            }

            throw new ApplicationException("INVALID_LOGIN_ATTEMPT");
        }

        [HttpPost]
        [Authorize(Roles = "Administrador")]
        public async Task<object> Register([FromBody] RegisterDto model)
        {    
            var user = new IdentityUser
            {
                UserName = model.UserName,
                Email = model.Email,
            };
            var result = await _userManager.CreateAsync(user, model.Password);


            if (result.Succeeded)
            {
                var result2 = await _userManager.AddToRoleAsync(user, model.Role);
                if (result2.Succeeded)
                {
                    await _signInManager.SignInAsync(user, false);
                    return new { mensaje = "Usuario creado exitosamente" };
                }
                else
                {
                    return StatusCode(400, new { result.Errors });
                }
            }
            else
            {
                return StatusCode(400, new { result.Errors });
            }
        }

        [HttpPost]
        [Authorize(Roles = "Administrador")]
        public async Task<object> crearRol(string nombreRol)
        {
            var result = await _roleManager.CreateAsync(new IdentityRole(nombreRol));

            if (result.Succeeded)
            {
                return new { mensaje = "Rol creado exitosamente" };
            }
            else
            {
                return StatusCode(400, new { result.Errors });
            }

        }

        [HttpGet]
        [Authorize(Roles = "Administrador")]
        public async Task<List<UsersDto>> getUsers() {
            List<UsersDto> result = new List<UsersDto>();
            List<IdentityUser> users = _userManager.Users.ToList();
            for (int i = 0; i < users.Count; i++)
            {
                var id = users[i].Id;
                var email = users[i].Email;
                var role = await _userManager.GetRolesAsync(users[i]);
                result.Add(new UsersDto(id, email, role[0]));
            }
            return result;
        }

        [HttpGet]
        [Authorize(Roles = "Administrador, Operador")]
        public async Task<UserDto> verUsuario()
        {
            var user = await _userManager.GetUserAsync(User);
            return new UserDto(user);
        }

        [HttpPut("{id}")]
        [Authorize(Roles = "Administrador")]
        public async Task<object> updateUser(string id, string email)
        {
            var user = await _userManager.FindByIdAsync(id);
            user.UserName = email;
            user.Email = email;

            var result = await _userManager.UpdateAsync(user);
            if (result.Succeeded)
            {
                return new { mensaje = "Usuario actualizado exitosamente" };
            }
            else
            {
                return StatusCode(400, new { result.Errors });
            }
        }

        [HttpPost]
        [Authorize(Roles = "Administrador")]
        public async Task<object> cambiarContrasena([FromBody] ChangePasswordDTO model)
        {
            var user = await _userManager.FindByIdAsync(model.id);
            var result = await _userManager.ChangePasswordAsync(user, model.oldPassword, model.newPassword);
            if (result.Succeeded)
            {
                return new { mensaje = "Contraseña actualizada exitosamente" };
            }
            else
            {
                return StatusCode(400, new { result.Errors });
            }
        }

        [HttpDelete("{id}")]
        [Authorize(Roles = "Administrador")]
        public async Task<object> deleUser(string id)
        {
            var user = await _userManager.FindByIdAsync(id);

            var result = await _userManager.DeleteAsync(user);
            if (result.Succeeded)
            {
                return new { mensaje = "Usuario eliminado exitosamente" };
            }
            else
            {
                return StatusCode(400, new { result.Errors });
            }
        }

        private object GenerateJwtToken(string email, IdentityUser user, IList<string> userRole)
        {   
            
            var claims = new List<Claim>
            {
                new Claim(JwtRegisteredClaimNames.Sub, user.UserName),
                new Claim(JwtRegisteredClaimNames.Email, email),
                new Claim(ClaimTypes.Role, userRole[0]),
                new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
                new Claim(JwtRegisteredClaimNames.NameId, user.Id),
                new Claim(ClaimTypes.NameIdentifier, user.Id)
            };
            
            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration["JwtKey"]));
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
            var expires = DateTime.Now.AddDays(Convert.ToDouble(_configuration["JwtExpireDays"]));

            var token = new JwtSecurityToken(
                _configuration["JwtIssuer"],
                _configuration["JwtIssuer"],
                claims,
                expires: expires,
                signingCredentials: creds
            );

            return new JwtSecurityTokenHandler().WriteToken(token);
        }

        public class LoginDto
        {
            [Required]
            public string Email { get; set; }

            [Required]
            public string Password { get; set; }

        }

        public class ChangePasswordDTO
        {
            [Required]
            public string id { get; set; }

            [Required]
            public string oldPassword { get; set; }

            [Required]
            public string newPassword { get; set; }

        }

        public class RegisterDto
        {
            [Required]
            public string Email { get; set; }
            public string UserName { get; set; }

            [Required]
            [StringLength(100, ErrorMessage = "PASSWORD_MIN_LENGTH", MinimumLength = 6)]
            public string Password { get; set; }

            [Required]
            public string Role { get; set; }
        }


        public class UserDto
        {
            public UserDto(IdentityUser user)
            {
                this.Id = user.Id;
                this.Email = user.Email;
                this.UserName = user.UserName;

            }
            [Required]
            public string Id { get; set; }

            [Required]
            public string Email { get; set; }

            [Required]
            public string UserName { get; set; }
        }

        public class UsersDto
        {
            public UsersDto(string id, string email, string role)
            {
                this.Id = id;
                this.Email = email;
                this.Role = role;

            }
            [Required]
            public string Id { get; set; }

            [Required]
            public string Email { get; set; }

            [Required]
            public string Role { get; set; }
        }
    }
}