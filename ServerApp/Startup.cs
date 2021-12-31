using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.AspNetCore.SpaServices.AngularCli;
using ServerApp.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;
using Microsoft.Extensions.FileProviders;
using System.IO;

namespace ServerApp {
    public class Startup {

        public Startup(IConfiguration configuration) {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        public void ConfigureServices(IServiceCollection services) {

            //string connectionString =
            //    Configuration["ConnectionStrings:DefaultConnection"];
            //services.AddDbContext<DataContext>(options =>
            //    options.UseSqlServer(connectionString));
            var IsDevelopment = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT") == "Development";

            var connectionString = IsDevelopment ? Configuration.GetConnectionString("DefaultConnection") : GetHerokuConnectionString();

            services.AddDbContext<DataContext>(options => options.UseNpgsql(connectionString));

            services.AddControllersWithViews()
                .AddJsonOptions(opts => {
                    opts.JsonSerializerOptions.IgnoreNullValues = true;
            }).AddNewtonsoftJson();
            services.AddRazorPages();

            // services.AddSwaggerGen(options => {
            //     options.SwaggerDoc("v1",
            //         new OpenApiInfo { Title = "SportsStore API", Version = "v1" });
            // });
            services.AddDistributedSqlServerCache(options => {
                options.ConnectionString = connectionString;
                options.SchemaName = "dbo";
                options.TableName = "SessionData";
            });
            services.AddSession(options => {
                options.Cookie.Name = "SportsStore.Session";
                options.IdleTimeout = System.TimeSpan.FromHours(48);
                options.Cookie.HttpOnly = false;
                options.Cookie.IsEssential = true;
            });
        }
        private static string GetHerokuConnectionString()
        {
            string connectionUrl = Environment.GetEnvironmentVariable("DATABASE_URL");

            var databaseUri = new Uri(connectionUrl);

            string db = databaseUri.LocalPath.TrimStart('/');
            string[] userInfo = databaseUri.UserInfo.Split(':', StringSplitOptions.RemoveEmptyEntries);

            return $"User ID={userInfo[0]};Password={userInfo[1]};Host={databaseUri.Host};Port={databaseUri.Port};Database={db};sslmode=Require;Trust Server Certificate=True;";
        }

        public void Configure(IApplicationBuilder app, IWebHostEnvironment env,
                IServiceProvider services) {

            if (env.IsDevelopment()) {
                app.UseDeveloperExceptionPage();
            } else {
                app.UseExceptionHandler("/Home/Error");
                app.UseHsts();
            }

            app.UseHttpsRedirection();
            app.UseStaticFiles();
            app.UseStaticFiles(new StaticFileOptions {
                RequestPath = "",
                FileProvider = new PhysicalFileProvider(
                    Path.Combine(Directory.GetCurrentDirectory(),
                        "./wwwroot/app"))
            });
            app.UseSession();

            app.UseRouting();
            app.UseAuthorization();

            app.UseEndpoints(endpoints => {
                endpoints.MapControllerRoute(
                    name: "default",
                    pattern: "{controller=Home}/{action=Index}/{id?}");

                endpoints.MapControllerRoute(
                    name: "angular_fallback",
                    //pattern: "{target:regex(table|detail)}/{*catchall}",
                    pattern: "{target:regex(store|cart|checkout|admin):nonfile}/{*catchall}",
                    defaults: new { controller = "Home", action = "Index" });
                    
                endpoints.MapRazorPages();
            });

            // app.UseSwagger();
            // app.UseSwaggerUI(options => {
            //     options.SwaggerEndpoint("/swagger/v1/swagger.json",
            //         "SportsStore API");
            // });

            // app.UseSpa(spa => {
            //     string strategy = Configuration
            //         .GetValue<string>("DevTools:ConnectionStrategy");
            //     if (strategy == "proxy") {
            //         spa.UseProxyToSpaDevelopmentServer("http://127.0.0.1:4200");
            //     } else if (strategy == "managed") {
            //         spa.Options.SourcePath = "../ClientApp";
            //         spa.UseAngularCliServer("start");
            //     }
            // });

            SeedData.SeedDatabase(services.GetRequiredService<DataContext>());
        }
    }
}
