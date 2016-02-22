Delayed::Worker.max_attempts = 1

DelayedJobWeb.use Rack::Auth::Basic do |username, password|
  username == Setting.delayed_job_web.user && password == Setting.delayed_job_web.password
end