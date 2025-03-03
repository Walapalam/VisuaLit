import { Row, Col } from "antd";
import { withTranslation } from "react-i18next";
import { Fade } from "react-awesome-reveal";
import { TeamSectionProps, TeamMemberProps } from "./types";
import {
  TeamSection,
  MemberCard,
  MemberImage,
  MemberName,
  MemberRole,
  SocialLinks,
  LinkedInButton
} from "./styles";

const LinkedInIcon = () => (
  <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
    <path d="M19 0h-14c-2.761 0-5 2.239-5 5v14c0 2.761 2.239 5 5 5h14c2.762 0 5-2.239 5-5v-14c0-2.761-2.238-5-5-5zm-11 19h-3v-11h3v11zm-1.5-12.268c-.966 0-1.75-.79-1.75-1.764s.784-1.764 1.75-1.764 1.75.79 1.75 1.764-.783 1.764-1.75 1.764zm13.5 12.268h-3v-5.604c0-3.368-4-3.113-4 0v5.604h-3v-11h3v1.765c1.396-2.586 7-2.777 7 2.476v6.759z"/>
  </svg>
);

const TeamMember = ({ image, name, role, linkedin }: TeamMemberProps) => (
  <MemberCard>
    <MemberImage src={image} alt={name} />
    <MemberName>{name}</MemberName>
    <MemberRole>{role}</MemberRole>
    {linkedin && (
      <SocialLinks>
        <LinkedInButton href={linkedin} target="_blank" rel="noopener noreferrer">
          <LinkedInIcon /> Connect
        </LinkedInButton>
      </SocialLinks>
    )}
  </MemberCard>
);

const TeamMembers = ({ title, subtitle, members, t }: TeamSectionProps & { t: any }) => {
  return (
    <TeamSection id="team">
      <Fade direction="up" triggerOnce>
        <h2>{t(title)}</h2>
        {subtitle && <p>{t(subtitle)}</p>}
        <Row gutter={[24, 24]} justify="center">
          {members.map((member, index) => (
            <Col key={index} xs={24} sm={12} md={8} lg={6}>
              <TeamMember {...member} />
            </Col>
          ))}
        </Row>
      </Fade>
    </TeamSection>
  );
};

export default withTranslation()(TeamMembers);