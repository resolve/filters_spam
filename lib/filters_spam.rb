def filters_spam(options = {})
  options = {
    :message_field => :message,
    :email_field => :email,
    :author_field => :author,
    :other_fields => [],
    :extra_spam_words => []
  }.update(options)

  self.module_eval do
    scope :ham, lambda {{:conditions => {:spam => false}, :order => 'created_at DESC'}}
    scope :spam, lambda {{:conditions => {:spam => true}, :order => 'created_at DESC'}}
    before_validation(:on => :create) { calculate_spam_score }

    cattr_accessor :spam_words
    self.spam_words = %w{
      -online 4u 4-u acne adipex advicer baccarrat blackjack bllogspot booker buy byob carisoprodol
      casino chatroom cialis coolhu credit-card-debt cwas cyclen cyclobenzaprine orgy
      day-trading debt-consolidation discreetordering duty-free dutyfree equityloans fioricet
      freenet free\s*shipping gambling- hair-loss homefinance holdem incest jrcreations leethal levitra macinstruct
      mortgagequotes nemogs online-gambling ottawavalleyag ownsthis paxil penis pharmacy phentermine
      poker poze pussy ringtones roulette shemale shoes -site slot-machine thorcarlson
      tramadol trim-spa ultram valeofglamorganconservatives viagra vioxx xanax zolus
    } | options[:extra_spam_words]
  end

  self.module_eval %{
    def ham?
      not spam?
    end

    def ham!
      self.update_attribute(:spam, false)
    end

    def spam!
      self.update_attribute(:spam, true)
    end

  protected

    # heavily based off http://github.com/rsl/acts_as_snook
    # which is based off http://snook.ca/archives/other/effective_blog_comment_spam_blocker

    def score_for_message_links
      link_count = self.#{options[:message_field]}.to_s.scan(/http:/).size
      link_count > 2 ? -link_count : 2
    end

    def score_for_message_length
      if self.#{options[:message_field]}.to_s.length > 20 and self.#{options[:message_field]}.to_s.scan(/http:/).size.zero?
        2
      else
        -1
      end
    end

    def score_for_previous_submissions
      current_score = 0

      self.class.find(:all, :conditions => {:#{options[:email_field]} => #{options[:email_field]}}).each do |i|
        if i.spam?
          current_score -= 1
        else
          current_score += 1
        end
      end

      current_score
    end

    def score_for_spam_words
      current_score = 0

      spam_words.each do |word|
        regex = /\#{word}/i
        if #{options[:message_field]} =~ regex ||
           #{options[:author_field]} =~ regex #{" || #{options[:other_fields].join(' =~ regex ')} =~ regex" if options[:other_fields].any?}
          current_score -= 1
        end
      end

      current_score
    end

    def score_for_suspect_url
      current_score = 0

      regex = /http:\\/\\/\\S*(\\.html|\\.info|\\?|&|free)/i
      current_score =- (1 * #{options[:message_field]}.to_s.scan(regex).size)
    end

    def score_for_suspect_tld
      regex = /http:\\/\\/\\S*\\.(de|pl|cn)/i
      #{options[:message_field]}.to_s.scan(regex).size * -1
    end

    def score_for_lame_message_start
      #{options[:message_field]}.to_s.strip =~ /^(interesting|sorry|nice|cool)/i ? -10 : 0
    end

    def score_for_author_link
      #{options[:author_field]}.to_s.scan(/http:/).size * -2
    end

    def score_for_same_message
      self.class.count(:conditions => {:#{options[:message_field]} => #{options[:message_field]}}) * -1
    end

    def score_for_consonant_runs
      current_score = 0

      [#{([options[:author_field], options[:message_field], options[:email_field]] | options[:other_fields]).join(', ')}].each do |field|
        field.to_s.scan(/[bcdfghjklmnpqrstvwxz]{5,}/).each do |run|
          current_score =- run.size - 4
        end
      end

      current_score
    end

    def calculate_spam_score
      score = 0
      score += score_for_message_links
      score += score_for_message_length
      score += score_for_previous_submissions
      score += score_for_spam_words
      score += score_for_suspect_tld
      score += score_for_lame_message_start
      score += score_for_author_link
      score += score_for_same_message
      score += score_for_consonant_runs
      self.spam = (score < 0)

      logger.info("spam score was \#{score}")

      true
    end
  }
end