module FilterSpam
  extend ActiveSupport::Concern

  included do
    scope :ham,   where(:spam => false)
    scope :spam,  where(:spam => true)

    # setup default configuration
    FilterSpam.configure

    before_validation(:on => :create) do |inquiry|
      inquiry.catch_spam
    end
  end

  module InstanceMethods
    def ham?
      not spam?
    end

    def ham!
      if self.persisted?
        update_attribute(:spam, false)
      else
        self.spam = false
      end
    end

    def spam!
      if self.persisted?
        update_attribute(:spam, true)
      else
        self.spam = true
      end
    end

    def catch_spam
      spam_score = 0

      spam_score += score_for_message_length_and_links
      spam_score += score_for_previous_submissions
      spam_score += score_for_spam_words
      spam_score += score_for_suspect_url
      spam_score += score_for_lame_message_start
      spam_score += score_for_author_link
      spam_score += score_for_same_message
      spam_score += score_for_consonant_runs

      self.spam = (spam_score > 0)

      true
    end

    protected
      def score_for_message_length_and_links
        current_score = 0

        if send(configuration.message_field).length < 20 and
          send(configuration.message_field).scan(/http:/).size >= 1
          current_score += 1
        elsif send(configuration.message_field).length > 25 and
          send(configuration.message_field).scan(/http:/).size >= 2
          current_score += 1
        end

        current_score
      end

      def score_for_previous_submissions
        current_score = 0

        self.class.where(configuration.email_field => send(configuration.email_field)).each do |i|
          current_score += 1 if i.spam?
        end

        current_score
      end

      def score_for_spam_words
        current_score = 0

        configuration.spam_words.each do |word|
          regex = /#{word}/i
          if send(configuration.message_field) =~ regex ||
              send(configuration.author_field) =~ regex
            current_score += 1
          end

          configuration.other_fields.each do |other_field|
            current_score += 1 if send(other_field) =~ regex
          end if configuration.other_fields.any?
        end

        current_score
      end

      def score_for_suspect_url
        regex = /http:\/\/\S*(\.html|\.info)/i
        send(configuration.message_field).scan(regex).size * 1
      end

      def score_for_lame_message_start
        send(configuration.message_field).strip =~ /^(interesting|sorry|nice|cool)/i ? 1 : 0
      end

      def score_for_author_link
        send(configuration.author_field).scan(/http:/).size * 1
      end

      def score_for_same_message
        self.class.where(configuration.message_field => send(configuration.message_field)).count * 1
      end

      def score_for_consonant_runs
        # implement this!
        0
      end
  end

  mattr_accessor :configuration

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration) if block_given?
  end

  class Configuration
    attr_accessor :message_field, :email_field, :author_field
    attr_reader :other_fields, :extra_spam_words

    def initialize
      @message_field    = :message
      @email_field      = :email
      @author_field     = :author
      @other_fields     = []
      @extra_spam_words = []
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
