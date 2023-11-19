<!DOCTYPE html>
<html t:params="$spot $loader $go_loader $is_public?">
<t:call x="use URL::PercentEncode">
<t:include path=_macro.html.tm />
<t:include path=_wrapper.html.tm m:is_public=$is_public>
<t:field name=title><t:text value="$spot->name">
<t:field name=body-attrs>
  <t:if x="$spot->has_latlon">
    <t:attr name="'data-spot-lat'" value="$spot->lat">
    <t:attr name="'data-spot-lon'" value="$spot->lon">
  </t:if>
  <t:attr name="'data-spot-name'" value="$spot->name">
<t:field name=edit>
  <a pl:href="$spot->path">スポット</a>
  <a pl:href="$spot->edit_path">編集</a>
  <a href="/pages/add">ページの追加</a>
<t:field>

<hgroup>
<t:if x="defined $spot->reading or defined $spot->roman">
  <h1>
    <ruby>
      <t:text value="$spot->name">
    <rt>
      <t:text value="$spot->reading // ''">
    <rt>
      <t:text value="$spot->roman // ''">
    </ruby>
  </h1>
<t:else>
  <h1><t:text value="$spot->name"></h1>
</t:if>
<t:if x="length $spot->location">
  <h2><t:text value="$spot->location"></h2>
</t:if>
</hgroup>

<div class=content>
  <nav class=content-links>
    <span class=lsf-icon data-icon=memo><a pl:href="'http://suika.suikawiki.org/~wakaba/wiki/sw/n/' . percent_encode_c $spot->name">ノート</a></span>
  </nav>

  <t:wait cv="$loader->load_linked_go_data_as_cv">
  <t:my as=$go_links x="$spot->go_links">
  <t:for as=$go_type x="[keys %$go_links]">
    <t:wait cv="$go_loader->load_by_type_as_cv ($go_type)">
  </t:for>

<div class=main>
  <t:my as=$parent_spots x="$loader->parent_spots">
  <nav class=breadcrumbs>
    <t:for as=$sp x=$parent_spots>
      <p><a pl:href="$sp->path"><t:text value="$sp->name"></a> > <t:text value="$spot->name">
    </t:for>
    <t:for as=$go_type x="[keys %$go_links]">
      <t:my as=$go_def x="$go_loader->get_go_def_by_type ($go_type)">
      <t:my as=$go_id x="$go_links->{$go_type}">
      <t:my as=$go x="$go_loader->get_go_by_type_and_id ($go_type, $go_id)">
      <m:go-breadcrumbs m:go_def=$go_def m:go=$go m:go_loader=$go_loader />
    </t:for>
  </nav>

  <t:if x="$spot->has_wikipedia and length $spot->wikipedia_summary">
    <section class=summary>
      <blockquote>
        <p><t:text value="$spot->wikipedia_summary"></p>
      </blockquote>
      <cite><a pl:href="$spot->wikipedia_url">フリー百科事典 ウィキペディア日本語版</a></cite>
    </section>
  </t:if>

  <t:if x="$spot->ksj_item">
    <t:my as=$ksj x="$spot->ksj_item">
    <t:if x="$ksj->type_as_string eq 'dam'">
      <section class=ksj-data>
        <t:class name="'ksj-'.$ksj->type_as_string">
        <table>
          <caption>
            <strong><t:text value="$ksj->data->{damName}">ダム</strong>
            (<t:text value="$ksj->data->{yearOfCompletion}">)
          </caption>
          <tbody>
            <tr>
              <th>位置
              <td>
                <t:text value="$ksj->data->{waterSystemName}">水系<t:text value="$ksj->data->{riverName}">
                (<t:text value="$ksj->data->{address}">)
            <tr>
              <th>形式
              <td>
                <t:text value="+{qw[
                  1 アーチダム
                  2 バットレスダム
                  3 アースダム
                  4 アスファルトフェイシングダム
                  5 アスファルトコアダム
                  6 フローティングゲートダム(可動堰)
                  7 重力式コンクリートダム
                  8 重力式アーチダム
                  9 重力式コンクリートダム・フィルダム複合ダム
                  10 中空重力式コンクリートダム
                  11 マルティプルアーチダム
                  12 ロックフィルダム
                  13 台形CSGダム
                ]}->{$ksj->data->{type}}">
            <tr>
              <th>規模
              <td>
                <strong>堤高</strong> <span class=with-unit><t:text value="$ksj->data->{damScaleBankHeight}"><span class=unit>m</span></span>
                <strong>堤頂長</strong> <span class=with-unit><t:text value="$ksj->data->{damScaleBankSpan}"><span class=unit>m</span></span>
                <strong>堤体積</strong> <span class=with-unit><t:text value="$ksj->data->{bankvolume}"><span class=unit>m<sup>3</sup></span></span>
                <strong>総貯水量</strong> <span class=with-unit><t:text value="$ksj->data->{totalpondage}"><span class=unit>m<sup>3</sup></span></span>
        </table>
        <footer class=credit>
          <a href="/about#ksj">国土数値情報 国土交通省</a>
        </footer>
      </section>
    </t:if>
  </t:if>

  <t:for as=$go_type x="[keys %$go_links]">
    <t:wait cv="$go_loader->load_by_type_as_cv ($go_type)">
    <t:my as=$go_def x="$go_loader->get_go_def_by_type ($go_type)">
    <t:my as=$go_id x="$go_links->{$go_type}">
    <t:my as=$go x="$go_loader->get_go_by_type_and_id ($go_type, $go_id)">
    <section class=go-data>
      <!--<t:if x="$go->has_latlon">
        <t:attr name="'data-spot-lat'" value="$go->lat">
        <t:attr name="'data-spot-lon'" value="$go->lon">
      </t:if>-->
      <h1><t:text value="$go->get_prop_value ('name')"></h1>

      <m:go-data m:go_def=$go_def m:go=$go m:go_loader=$go_loader />
    </section>
  </t:for>

  <section class=main-spots>
    <t:for as=$item x="$loader->get_items_by_spot_and_type ($spot, 'main')">
      <t:my as=$page x="$item->{page}">
      <t:my as=$youtube_url x="$item->{weight} >= 100 ? $page->youtube_embed_url : undef">
      <article class=page>
        <t:class name="defined $youtube_url ? 'youtube-video' : undef">
        <header>
          <h1>
            <a pl:href="$page->url"><t:text value="$page->any_title"></a>
            <m:page-seq-pages m:pages="$item->{seq_pages}"/>
          </h1>
          <p class=host><t:text value="$page->url_hostname"></p>
        </header>
        <div class=info>
          <t:if x="defined $page->timestamp">
            <p><time pl:datetime="my @t = gmtime $page->timestamp;
                                  sprintf '%04d-%02d-%02dT%02d:%02d:%02dZ',
                                      $t[5]+1900, $t[4]+1, $t[3],
                                      $t[2], $t[1], $t[0]">
              <t:text value="my @t = localtime $page->timestamp;
                             sprintf '%04d/%02d/%02d',
                                 $t[5]+1900, $t[4]+1, $t[3]">
            </time>
          </t:if>
          <p class=counts>
            <t:if x="$page->photo_count">
              <span class=lsf-icon data-icon=camera title=写真><t:text value="$page->photo_count"></span>
            </t:if>
            <t:if x="$page->map_count">
              <span class=lsf-icon data-icon=earth title=地図><t:text value="$page->map_count"></span>
            </t:if>
            <t:if x="$page->video_count">
              <span class=lsf-icon data-icon=video title=動画><t:text value="$page->video_count"></span>
            </t:if>
        </div>
        <t:if x="defined $youtube_url or defined $page->summary">
          <blockquote class=summary>
            <t:if x=$youtube_url>
              <iframe pl:src=$youtube_url class=youtube></iframe>
              <p><t:text value="substr $page->summary, 0, 200">...
            <t:else>
              <p><t:text value="substr $page->summary, 0, 100">...
            </t:if>
          </blockquote>
        </t:if>

        <div class="edit edit-mode">
          <a pl:href="$page->path">ページ</a>
          <m:edit_spot_page_weight m:spot=$spot m:page=$page m:weight="$item->{weight}"/>
        </div>
      </article>
    </t:for>
  </section>

  <t:if x="$spot->has_wikipedia">
    <section class=wikipedia>
      <h1><a pl:href="$spot->wikipedia_url">Wikipedia: <t:text value="$spot->wikipedia_ja_page"></a></h1>
      <t:if x="@{$spot->wikipedia_headings or []}">
        <ul>
          <t:for as=$h x="$spot->wikipedia_headings">
            <li><a pl:href="$spot->get_wikipedia_section_url ($h)"><t:text value="$h"></a>
          </t:for>
        </ul>
      </t:if>
    </section>
  </t:if>

  <div class=additional-spots>
    <ul class=additional-list>
      <t:for as=$item x="$loader->get_items_by_spot_and_type ($spot, 'additional')">
        <t:my as=$page x="$item->{page}">
        <li class=page>
          <a pl:href="$page->url" pl:title="substr $page->summary // '', 0, 100"><t:text value="$page->any_title"></a>
          <m:page-seq-pages m:pages="$item->{seq_pages}"/>
          <span class=host><t:text value="$page->url_hostname"></span>
          <span class=counts>
            <t:if x="$page->photo_count">
              <span class=lsf-icon data-icon=camera title=写真><t:text value="$page->photo_count"></span>
            </t:if>
            <t:if x="$page->map_count">
              <span class=lsf-icon data-icon=earth title=地図><t:text value="$page->map_count"></span>
            </t:if>
            <t:if x="$page->video_count">
              <span><dd class=lsf-icon data-icon=video title=動画><t:text value="$page->video_count"></span>
            </t:if>
          </span>
          <div class="edit edit-mode">
            <a pl:href="$page->path">ページ</a>
            <m:edit_spot_page_weight m:spot=$spot m:page=$page m:weight="$item->{weight}"/>
          </div>
      </t:for>
    </ul>
  </div>

  <div class=child-spots>
    <t:for as=$csp x="$loader->child_spots">
      <section class=child-spot pl:data-spot-name="$csp->name">
        <t:if x="$csp->has_latlon">
          <t:attr name="'data-spot-lat'" value="$csp->lat">
          <t:attr name="'data-spot-lon'" value="$csp->lon">
        </t:if>
        <h1><a pl:href="$csp->path">
          <t:if x="defined $csp->reading">
            <ruby>
              <t:text value="$csp->name">
            <rt>
              <t:text value="$csp->reading">
            </ruby>
          <t:else>
            <t:text value="$csp->name">
          </t:if>
        </a></h1>

        <ul>
          <t:for as=$item x="$loader->get_items_by_spot_and_type ($csp, 'all')">
            <t:my as=$page x="$item->{page}">
            <li class=page>
              <a pl:href="$page->url" pl:title="substr $page->summary // '', 0, 100"><t:text value="$page->any_title"></a>
              <m:page-seq-pages m:pages="$item->{seq_pages}"/>
          </t:for>
        </ul>
      </section>
    </t:for>

    <t:for as=$go_type x="[keys %$go_links]">
      <t:my as=$go_def x="$go_loader->get_go_def_by_type ($go_type)">
      <t:my as=$go_id x="$go_links->{$go_type}">
      <t:my as=$go x="$go_loader->get_go_by_type_and_id ($go_type, $go_id)">
      <m:go-children m:go_def=$go_def m:go=$go m:go_loader=$go_loader />
    </t:for>
  </div>

  <section class=links>
    <ul>
      <li class=lsf-icon data-icon=search><a pl:href="$spot->google_url">Google 検索: <t:text value="$spot->google_word"></a>
      <li class=lsf-icon data-icon=image><a pl:href="$spot->google_image_url">Google 画像検索: <t:text value="$spot->google_word"></a>
    </ul>
  </section>
</div><!-- main -->

<div class=side>
  <ul class=additional-names>
    <t:for as=$n x="$spot->additional_names">
      <li>
        <t:if x="defined $n->{reading}">
          <ruby>
            <t:text value="$n->{name}">
          <rt>
            <t:text value="$n->{reading}">
          </ruby>
        <t:else>
          <t:text value="$n->{name}">
        </t:if>
    </t:for>
    <t:for as=$go_type x="[keys %$go_links]">
      <t:my as=$go_def x="$go_loader->get_go_def_by_type ($go_type)">
      <t:my as=$go_id x="$go_links->{$go_type}">
      <t:my as=$go x="$go_loader->get_go_by_type_and_id ($go_type, $go_id)">
      <m:go-names m:go_def=$go_def m:go=$go m:go_loader=$go_loader />
    </t:for>
  </ul>

  <t:if x="$spot->has_wikipedia">
    <t:if x="$spot->wikipedia_image_thumbnail_url">
      <figure>
        <a pl:href="$spot->wikipedia_image_url"><img pl:src="$spot->wikipedia_image_thumbnail_url"></a>
      </figure>
    </t:if>
  </t:if>
  <t:for as=$go_type x="[keys %$go_links]">
    <t:my as=$go_def x="$go_loader->get_go_def_by_type ($go_type)">
    <t:my as=$go_id x="$go_links->{$go_type}">
    <t:my as=$go x="$go_loader->get_go_by_type_and_id ($go_type, $go_id)">
    <m:go-images m:go_def=$go_def m:go=$go m:go_loader=$go_loader />
  </t:for>

  <div id=map class=map></div>
  <script>
    createMapFromSpotList ('map', '[data-spot-lat][data-spot-lon]');
  </script>

  <m:ads-rectangle/>

  <t:my as=$related_spots x="$loader->related_spots">
  <t:if x="@$related_spots">
    <section class=related-spots>
      <h1>関連</h1>
      <ul>
        <t:for as=$rsp x="$related_spots">
          <li><a pl:href="$rsp->path"><t:text value="$rsp->name"></a>
        </t:for>
      </ul>
    </section>
  </t:if>
</div>
</div>

</t:include>
