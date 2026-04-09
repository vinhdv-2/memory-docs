import clsx from 'clsx';
import Heading from '@theme/Heading';
import styles from './styles.module.css';

const FeatureList = [
  {
    title: 'Dễ sử dụng',
    Svg: require('@site/static/img/undraw_docusaurus_mountain.svg').default,
    description: (
      <>
        Viết tài liệu bằng Markdown, upload media lên MinIO và sử dụng URL đơn giản.
        Không cần cấu hình phức tạp.
      </>
    ),
  },
  {
    title: 'Tập trung vào nội dung',
    Svg: require('@site/static/img/undraw_docusaurus_tree.svg').default,
    description: (
      <>
        Chỉ cần tập trung viết tài liệu. Docusaurus và MinIO sẽ lo phần còn lại.
        Hot reload giúp bạn thấy thay đổi ngay lập tức.
      </>
    ),
  },
  {
    title: 'Chạy mọi nơi với Docker',
    Svg: require('@site/static/img/undraw_docusaurus_react.svg').default,
    description: (
      <>
        Setup hoàn toàn trên Docker, dễ dàng triển khai trên nhiều môi trường khác nhau.
        Production-ready ngay từ đầu.
      </>
    ),
  },
];

function Feature({Svg, title, description}) {
  return (
    <div className={clsx('col col--4')}>
      <div className="text--center">
        <Svg className={styles.featureSvg} role="img" />
      </div>
      <div className="text--center padding-horiz--md">
        <Heading as="h3">{title}</Heading>
        <p>{description}</p>
      </div>
    </div>
  );
}

export default function HomepageFeatures() {
  return (
    <section className={styles.features}>
      <div className="container">
        <div className="row">
          {FeatureList.map((props, idx) => (
            <Feature key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}
