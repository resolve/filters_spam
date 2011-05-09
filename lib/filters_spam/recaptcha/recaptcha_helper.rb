module FiltersSpam
  module Recaptcha
    module RecaptchaHelper
      class ActionView::Helpers::FormBuilder
        def recaptcha
          html = "
            <script type=\"text/javascript\"
              src=\"http://www.google.com/recaptcha/api/challenge?k=#{FiltersSpam.configuration.recaptcha_public_key}\">
            </script>
            <noscript>
              <iframe src=\"http://www.google.com/recaptcha/api/noscript?k=#{FiltersSpam.configuration.recaptcha_public_key}\"
                height=\"300\" width=\"500\" frameborder=\"0\"></iframe><br>
              <textarea name=\"recaptcha_challenge_field\" rows=\"3\" cols=\"40\">
              </textarea>
              <input type=\"hidden\" name=\"recaptcha_response_field\"
                value=\"manual_challenge\">
            </noscript>"

          jquery = "
            <script>
              $('#recaptcha_challenge_field').attr('name', '#{object_name}[recaptcha_challenge_field]');
              $('#recaptcha_response_field').attr('name', '#{object_name}[recaptcha_response_field]');
            </script>"

          (html << jquery).html_safe
        end
      end
    end
  end
end
