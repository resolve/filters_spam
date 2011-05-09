module FiltersSpam
  class Configuration
    attr_accessor :message_field, :email_field, :author_field, :use_recaptcha,
                  :recaptcha_public_key, :recaptcha_private_key
    attr_reader :other_fields, :extra_spam_words

    def initialize
      @message_field          = :message
      @email_field            = :email
      @author_field           = :author
      @other_fields           = []
      @extra_spam_words       = []
      @use_recaptcha          = false
      @recaptcha_public_key   = ENV['RECAPTCHA_PUBLIC_KEY']
      @recaptcha_private_key  = ENV['RECAPTCHA_PRIVATE_KEY']
    end

    def other_fields=(other)
      @other_fields = @other_fields | Array.wrap(other)
    end

    def extra_spam_words=(extra)
      @extra_spam_words = @extra_spam_words | Array.wrap(extra)
    end

    def spam_words
      %w(-online 4u 4-u acne adipex advicer baccarrat blackjack bllogspot booker buy byob carisoprodol
      casino chatroom cialis coolhu credit-card-debt cwas cyclen cyclobenzaprine orgy
      day-trading debt-consolidation discreetordering duty-free dutyfree equityloans fioricet
      freenet free\s*shipping gambling- hair-loss homefinance holdem incest jrcreations leethal levitra macinstruct
      mortgagequotes nemogs online-gambling ottawavalleyag ownsthis paxil penis pharmacy phentermine
      poker poze pussy ringtones roulette shemale shoes -site slot-machine thorcarlson
      tramadol trim-spa ultram valeofglamorganconservatives viagra vioxx xanax zolus
      ) | (@extra_spam_words ||= [])
    end
  end
end
