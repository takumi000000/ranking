class ChartsController < ApplicationController
    def monthly
        # 月ごとユーザーごとで勉強時間を集計
        # 集計時間の降順で並べ替え
      
          if params[:pre_preview].present?
            @target_month = Date.parse(params[:pre_preview]) << 1
          elsif params[:next_preview].present?
            @target_month = Date.parse(params[:next_preview]) >> 1
          else
            @target_month = Time.current.to_date << 1
          end
      
          # カテゴリ、ユーザーID、1ヶ月分で絞り込み、総勉強時間（h）と（m）の合計を取得
          @ranks = Post.joins(:items)
                      .select("posts.user_id
                              ,sum(items.study_hour) as study_hour
                              ,sum(items.study_minutes) as study_minutes
                              ,to_char(posts.study_date,'YYYY') as study_year 
                              ,to_char(posts.study_date,'MM') as study_month
                              ,round(sum(items.study_hour) + (cast(sum(items.study_minutes) as decimal)  / 60),2) as study_total
                              ,RANK () OVER (PARTITION BY to_char(posts.study_date,'YYYY'),to_char(posts.study_date,'MM') order by (sum(items.study_hour) + cast(sum(items.study_minutes)as decimal) / 60) desc) as rank_number")
                      .where(study_date: @target_month.all_month)
                      .group("to_char(posts.study_date,'YYYY')
                              ,to_char(posts.study_date,'MM')
                              ,posts.user_id")
                      .order("(sum(items.study_hour) + cast(sum(items.study_minutes)as decimal) / 60) desc")
          @my_rank = 0
          @ranks.each do |rank|
            if rank.user_id == current_user.id
              @my_rank = rank.rank_number
              break
            end
          end
      
        end 
end
