import { globalRegistry, Utility } from 'component-registry';
import { componentDidAppear, componentWillDisappear } from 'inferno-animation';
import { IStingerTransitionUtil } from 'streamix-interfaces';
import * as config from './streamix_package.json';
import './component.scss';

function Title({value, ...other}) {
  return (
    <div className="Title">
      <div className="inner">
        <span className="name">{value['name']}</span>
        <span className="title">{value['title']}</span>
      </div>
    </div>
  )
}

function Background({...other}) {
  return (
    <div className="Background">
      <div className="Plate"></div>
      <div className="Bar_1"></div>
      <div className="Bar_2"></div>
      <div className="Bar_3"></div>
      <div className="Bar_4"></div>
      <div className="Bar_5"></div>
    </div>
  )
}

@globalRegistry.register
export default class StingerTransitionUtil extends Utility<IStingerTransitionUtil> {
  static __implements__ = IStingerTransitionUtil;
  static __name__ = config.name;

  static __Component__({id, name, isStaged, data}) {
    return <div className={config.name}>
      {isStaged && <Background 
        onComponentDidAppear={componentDidAppear}
        onComponentWillDisappear={componentWillDisappear}
        animation="Background" />}
      {isStaged && <Title
        value={data}
        onComponentDidAppear={componentDidAppear}
        onComponentWillDisappear={componentWillDisappear}
        animation="Title" />}
    </div>
  }
}