class Feed
  def initialize(posts:)
    @posts = posts.order(created_at: :desc).limit(5)
    @comment_cache = build_comment_cache
  end

  def posts
    @posts.map { |post| PostWithLatestComments.new(post, @comment_cache) }
  end

  private

  def build_comment_cache
    comments.group_by(&:post_id)
  end

  def comments
    Comment.
      select("*").
      from(Arel.sql("(#{ranked_comments_query}) AS ranked_comments")).
      where("comment_rank <= 3")
  end

  def ranked_comments_query
    Comment.where(post_id: @posts.map(&:id)).select(<<-SQL).to_sql
      comments.*,
      dense_rank() OVER (
        PARTITION BY comments.post_id
        ORDER BY comments.created_at DESC
      ) AS comment_rank
    SQL
  end
end
